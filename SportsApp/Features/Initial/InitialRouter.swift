//
//  InitialRouter.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright © 2018 Test CondorLabs LTD. All rights reserved.
//

import UIKit
import RxSwift
import XCoordinator

protocol InitialRouterInput {
    func presentTeamList()
}

class InitialRouter: BaseRouter, InitialRouterInput {
    func presentTeamList() {
        let configurator = TeamListConfigurator.module(inputData: TeamListViewModel.ModuleInputData(router: TeamListCoordinator().anyRouter))
        if let viewCtrl = configurator?.0 {
            self.present(viewController: viewCtrl, withNavigationCtrl: true)
        }
    }
}
