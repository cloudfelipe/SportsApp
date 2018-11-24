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

protocol TeamListViewOutput {
    func configure(input: TeamListViewModel.Input) -> TeamListViewModel.Output
}

class TeamListViewModel: RxViewModelType, RxViewModelModuleType, TeamListViewOutput {
    
    typealias TeamWrapper = TeamListTableViewCellModel
    
    // MARK: In/Out struct
    struct InputDependencies {
        
    }
    
    struct Input {
        let appearState: Observable<ViewAppearState>
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
        
        //Samples teams
        let team1 = Team()
        team1.name = "Atletico Nacional"
        team1.stadium = "Atanacio Girardot"
        team1.badge = ""
        
        let team2 = Team()
        team2.name = "Millonarios"
        team2.stadium = "El Campin"
        team2.badge = ""
        
        self.teams.accept([team1, team2])
    }
    
    // MARK: - TeamListViewOutput
    
    func configure(input: Input) -> Output {
        // Configure input
        input.appearState.subscribe(onNext: { _ in
            // .didLoad and etc
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
    private func prepareWrappers(for teams: [Team]) -> [TeamWrapper] {
        return teams.map { (team) -> TeamWrapper in
            let wrapper = TeamWrapper(teamName: team.name ?? "N/A",
                                      teamStadium: team.stadium ?? "N/A",
                                      teamBadge: team.badge ?? "N/A")
            return wrapper
        }
    }
}
