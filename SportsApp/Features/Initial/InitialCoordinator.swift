//
//  InitialCoordinator.swift
//  SportsApp
//
//  Created by Felipe Correa on 5/15/19.
//  Copyright © 2019 Test CondorLabs LTD. All rights reserved.
//

import Foundation
import XCoordinator

enum AppRoute: Route {
    case login
    case home
}

class IntialCoordinator: NavigationCoordinator<AppRoute> {
    
    var teamList: Presentable?
    
    init() {
        super.init(initialRoute: .login)
    }
    
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .home:
            self.teamList = TeamListCoordinator()
            return .present(teamList!)
//            let moduleData = TeamListViewModel.ModuleInputData(router: anyRouter)
//            if let module = TeamListConfigurator.module(inputData: moduleData) {
//                return .present(module.0)
//            } else {
//                fatalError()
//            }
        case .login:
            let moduleInput = LoginViewModel.ModuleInput(router: anyRouter)
            let moduleData = LoginViewModel.ModuleInputData()
            if let module = LoginConfigurator.module(inputData: moduleData,
                                                     moduleInput: moduleInput) {
                return .present(module.0)
            } else {
                fatalError()
            }
        }
        fatalError()
    }
}
