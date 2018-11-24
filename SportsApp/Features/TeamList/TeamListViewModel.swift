//
//  TeamListViewModel.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright (c) 2018 Test CondorLabs LTD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

import AlamofireImage
import Alamofire

protocol TeamListViewOutput {
    func configure(input: TeamListViewModel.Input) -> TeamListViewModel.Output
}

class TeamListViewModel: RxViewModelType, RxViewModelModuleType, TeamListViewOutput {
    
    typealias TeamWrapper = TeamListTableViewCellModel
    
    // MARK: In/Out struct
    struct InputDependencies {
        let router: TeamListRouterInput
        let teamServices: TeamServicesInput
    }
    
    struct Input {
        let appearState: Observable<ViewAppearState>
        let teamDidSelectedAtIndex: Driver<IndexPath>
        let segmentedItemSelectedAtIndex: Driver<Int>
    }
    
    struct Output {
        let title: Observable<String>
        let state: Observable<ModelState>
        let teamsWrapper: Observable<[TeamWrapper]>
    }
    
    // MARK: Dependencies
    private let dep: InputDependencies
    private let moduleInputData: ModuleInputData
    
    // MARK: Properties
    private let bag = DisposeBag()
    private let modelState: RxViewModelStateProtocol = RxViewModelState()
    
    // MARK: Observables
    private let title = Observable.just("TeamList")
    private let outputModuleAction = PublishSubject<OutputModuleActionType>()
    
    private let teams = BehaviorRelay<[Team]>(value: [])
    
    // MARK: - initializer
    
    init(dependencies: InputDependencies, moduleInputData: ModuleInputData) {
        self.dep = dependencies
        self.moduleInputData = moduleInputData
        
        
    }
    
    // MARK: - TeamListViewOutput
    
    func configure(input: Input) -> Output {
        // Configure input
        input.appearState.subscribe(onNext: { _ in
            // .didLoad and etc
        }).disposed(by: bag)
        
        input.teamDidSelectedAtIndex
            .drive(onNext: { [unowned self] (indexPath) in
                self.showTeamDetailAt(index: indexPath)
            }).disposed(by: bag)
        
        input.segmentedItemSelectedAtIndex
            .drive(onNext: { (index) in
                if let league = Leagues.init(rawValue: index) {
                    self.getTeamsFor(league: league)
                }
            }).disposed(by: bag)
        
        let teamWrappers = teams.map { self.prepareWrappers(for: $0) }.asObservable()
        // Configure output
        return Output(
            title: title.asObservable(),
            state: modelState.state.asObservable(),
            teamsWrapper: teamWrappers
        )
    }
    
    // MARK: - Module configuration
    
    func configureModule(input: ModuleInput?) -> ModuleOutput {
        // Configure input signals
        
        // Configure module output
        return ModuleOutput(
            moduleAction: outputModuleAction.asObservable()
        )
    }
    
    // MARK: - Additional
    
    deinit {
        print("-- TeamListViewModel dead")
    }
}

extension TeamListViewModel {
    
    private func getTeamsFor(league: Leagues) {
        //Clean previous getted teams
        self.teams.accept([])
        //Inform that a request is running
        self.modelState.change(state: .networkActivity)
        dep.teamServices.getTeams(by: league.identifier) { (list, error) in
            if error != nil {
                self.modelState.show(error: error!)
                print("Error getting teams: Reason \(error!.localizedDescription)")
                return
            }
            
            if let list = list {
                self.teams.accept(list)
                self.modelState.change(state: .normal)
            } else {
                self.modelState.change(state: .empty)
            }
        }
    }
    
    private func prepareWrappers(for teams: [Team]) -> [TeamWrapper] {
        return teams.map { (team) -> TeamWrapper in
            let wrapper = TeamWrapper(teamName: team.name ?? "N/A",
                                      teamStadium: team.stadium ?? "N/A",
                                      teamBadge: team.badge ?? "N/A")
            return wrapper
        }
    }
    
    private func showTeamDetailAt(index: IndexPath) {
        let team = self.teams.value[index.row]
        self.dep.router.showTeam(team)
    }
}
