//
//  MainCoordinators.swift
//  SportsApp
//
//  Created by Felipe Correa on 5/14/19.
//  Copyright © 2019 Test CondorLabs LTD. All rights reserved.
//

import UIKit

protocol MainCoordinatorType: CoordinatorType {
    func presentTeamList()
}

class MainCoordinator: MainCoordinatorType {
    
    var childCoordinators: [CoordinatorType] = []
    
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
    
    func start() {
        let moduleInput = InitialViewModel.ModuleInput(coordinator: self)
        let data = InitialViewModel.ModuleInputData()
        guard let module = InitialConfigurator.module(inputData: data,
                                                      moduleInput: moduleInput) else {
            return
        }
        navigationController.pushViewController(module.0, animated: false)
    }
    
    func presentTeamList() {
        if let presented = self.navigationController.viewControllers.first {
            let navCtrl = UINavigationController()
            navCtrl.navigationBar.isTranslucent = false
            let teamListCoord = TeamListCoordinator(navigationController: navCtrl)
            self.childCoordinators.append(teamListCoord)
            teamListCoord.start()
            presented.present(navCtrl, animated: true, completion: nil)
        }
    }
}
