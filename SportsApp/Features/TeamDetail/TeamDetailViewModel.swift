//
//  TeamDetailViewModel.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright (c) 2018 Test CondorLabs LTD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct TeamDetailViewInfo {
    var name: String?
    var description: String?
    var stadiumName: String?
    var stadiumImageUrl: String?
    var jerse: String?
    var jerseImageUrl: String?
}

protocol TeamDetailViewOutput {
    func configure(input: TeamDetailViewModel.Input) -> TeamDetailViewModel.Output
}

class TeamDetailViewModel: RxViewModelType, RxViewModelModuleType, TeamDetailViewOutput {
    
    // MARK: In/Out struct
    struct InputDependencies {
        
    }
    
    struct Input {
        let appearState: Observable<ViewAppearState>
        let socialNetworkDidSelectedAtIndex: Driver<IndexPath>
    }
    
    struct Output {
        let title: Observable<String>
        let state: Observable<ModelState>
        let viewInfo: Observable<TeamDetailViewInfo?>
        let socialNetworks: Observable<[SocialNetwork]>
    }
    
    // MARK: Dependencies
    private let dep: InputDependencies
    private let moduleInputData: ModuleInputData
    
    // MARK: Properties
    private let bag = DisposeBag()
    private let modelState: RxViewModelStateProtocol = RxViewModelState()
    
    private let viewInfoUpdated = BehaviorRelay<TeamDetailViewInfo?>(value: nil)
    private let availableSocialNetworks = BehaviorRelay<[SocialNetwork]>(value: [])
    // MARK: Observables
    private let title = Observable.just("TeamDetail")
    private let outputModuleAction = PublishSubject<OutputModuleActionType>()
    
    // MARK: - initializer
    
    init(dependencies: InputDependencies, moduleInputData: ModuleInputData) {
        self.dep = dependencies
        self.moduleInputData = moduleInputData
        self.prepareViewInfo(with: moduleInputData.team)
    }
    
    // MARK: - TeamDetailViewOutput
    
    func configure(input: Input) -> Output {
        // Configure input
        input.appearState.subscribe(onNext: { _ in
            // .didLoad and etc
        }).disposed(by: bag)
        
        input.socialNetworkDidSelectedAtIndex
            .drive(onNext: { [unowned self] (indexPath) in
                self.openSocialNetworkAt(indexPath: indexPath)
            }).disposed(by: bag)
        
        // Configure output
        return Output(
            title: title.asObservable(),
            state: modelState.state.asObservable(),
            viewInfo: viewInfoUpdated.asObservable(),
            socialNetworks: availableSocialNetworks.asObservable()
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
    
    private func openSocialNetworkAt(indexPath: IndexPath) {
        let socialNwk = availableSocialNetworks.value[indexPath.row]
        self.outputModuleAction.onNext(.showWebpage(url: socialNwk.url))
    }
    
    // MARK: - Additional
    
    deinit {
        print("-- TeamDetailViewModel dead")
    }
}

extension TeamDetailViewModel {
    private func prepareViewInfo(with team: Team) {
        let info = TeamDetailViewInfo(name: team.name,
                                      description: team.teamDescriptionEN,
                                      stadiumName: team.stadium,
                                      stadiumImageUrl: team.stadiumThumb,
                                      jerse: "Jerse",
                                      jerseImageUrl: team.jerse)
        self.viewInfoUpdated.accept(info)
        
        self.availableSocialNetworks.accept(team.socialNetworks)
    }
}
