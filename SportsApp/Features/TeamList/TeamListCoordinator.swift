//
//  TeamListCoordinator.swift
//  SportsApp
//
//  Created by Felipe Correa on 5/14/19.
//  Copyright © 2019 Test CondorLabs LTD. All rights reserved.
//

import UIKit

protocol TeamListCoordinatorType: CoordinatorType {
    func showTeam(_ team: Team)
}

class TeamListCoordinator: TeamListCoordinatorType {
    var childCoordinators: [CoordinatorType] = []
    
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let moduleInput = TeamListViewModel.ModuleInput(coordinator: self)
        let moduleData = TeamListViewModel.ModuleInputData()
        let configurator = TeamListConfigurator.module(inputData: moduleData, moduleInput: moduleInput)
        if let viewCtrl = configurator?.0 {
            self.navigationController.pushViewController(viewCtrl, animated: false)
        }
    }
    
    func showTeam(_ team: Team) {
        if let module = TeamDetailConfigurator.module(inputData: TeamDetailViewModel.ModuleInputData(team: team)) {
            self.navigationController.pushViewController(module.0, animated: true)
        }
    }
}
