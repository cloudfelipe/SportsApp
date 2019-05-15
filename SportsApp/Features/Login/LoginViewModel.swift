//
//  LoginViewModel.swift
//  SportsApp
//
//  Created by Felipe Correa on 5/15/19.
//  Copyright © 2019 Test CondorLabs LTD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import XCoordinator

protocol LoginViewModelOutput {
    func configure(input: LoginViewModel.Input) -> LoginViewModel.Output
}

class LoginViewModel: RxViewModelType, RxViewModelModuleType, LoginViewModelOutput {

    // MARK: In/Out struct
    struct InputDependencies {
        let router: AnyRouter<AppRoute>?
    }
    
    struct Input {
        let appearState: Observable<ViewAppearState>
        let loginAction: Driver<Void>
    }
    
    struct Output {
        let title: Observable<String?>
    }
    
    // MARK: Dependencies
    private let dep: InputDependencies
    private let moduleInputData: ModuleInputData
    
    // MARK: Properties
    private let bag = DisposeBag()
    private let modelState: RxViewModelStateProtocol = RxViewModelState()
    
    private let viewInfoUpdated = BehaviorRelay<TeamDetailViewInfo?>(value: nil)
    // MARK: Observables
    private let title = BehaviorRelay<String?>(value: nil)
    private let outputModuleAction = PublishSubject<OutputModuleActionType>()
    
    // MARK: - initializer
    
    init(dependencies: InputDependencies, moduleInputData: ModuleInputData) {
        self.dep = dependencies
        self.moduleInputData = moduleInputData
    }
    
    // MARK: - TeamDetailViewOutput
    
    func configure(input: Input) -> Output {
        
        input.loginAction.drive(onNext: {
            self.dep.router?.trigger(.home)
        }).disposed(by: bag)
        
        // Configure output
        return Output(
            title: title.asObservable()
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
        print("-- TeamDetailViewModel dead")
    }
}

extension LoginViewModel {
    
    enum OutputModuleActionType {
    }
    
    // MARK: - initial module data
    struct ModuleInputData {
    }
    
    // MARK: - module input structure
    struct ModuleInput {
        let router: AnyRouter<AppRoute>
    }
    
    // MARK: - module output structure
    struct ModuleOutput {
        let moduleAction: Observable<OutputModuleActionType>
    }
}
