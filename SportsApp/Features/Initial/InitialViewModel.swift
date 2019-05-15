//
//  InitialViewModel.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright (c) 2018 Test CondorLabs LTD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol InitialViewOutput {
    func configure(input: InitialViewModel.Input) -> InitialViewModel.Output
}

class InitialViewModel: RxViewModelType, RxViewModelModuleType, InitialViewOutput {
    
    // MARK: In/Out struct
    struct InputDependencies {
        weak var mainCoordinator: MainCoordinatorType?
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
    private let title = Observable.just("Initial")
    private let outputModuleAction = PublishSubject<OutputModuleActionType>()
    
    // MARK: - initializer
    
    init(dependencies: InputDependencies, moduleInputData: ModuleInputData) {
        self.dep = dependencies
        self.moduleInputData = moduleInputData
    }
    
    // MARK: - InitialViewOutput
    
    func configure(input: Input) -> Output {
        // Configure input
        input.appearState.subscribe(onNext: { viewState in
            switch viewState {
            case .willAppear:
                self.showSuitableController()
            default:
                break
            }
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
    
    /// This method shows the suitable controller according to some internal requirement
    /// For this app, only show the main sport list
    private func showSuitableController() {
        self.dep.mainCoordinator?.presentTeamList()
    }
    
    deinit {
        print("-- InitialViewModel dead")
    }
}
