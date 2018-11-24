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
    
    // MARK: In/Out struct
    struct InputDependencies {
        
    }
    
    struct Input {
        let appearState: Observable<ViewAppearState>
    }
    
    struct Output {
        let title: Observable<String>
        let state: Observable<ModelState>
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
    
//    private let teams: Variable<>
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
        
        // Configure output
        return Output(
            title: title.asObservable(),
            state: modelState.state.asObservable()
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
