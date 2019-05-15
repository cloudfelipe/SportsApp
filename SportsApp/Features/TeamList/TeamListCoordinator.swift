//
//  TeamListCoordinator.swift
//  SportsApp
//
//  Created by Felipe Correa on 5/14/19.
//  Copyright © 2019 Test CondorLabs LTD. All rights reserved.
//

import UIKit
import TOWebViewController

protocol TeamListCoordinatorType: CoordinatorType {
    func showTeam(_ team: Team)
}

protocol TeamDetailCoordinatorType: CoordinatorType {
    func presentWebView(page: String)
}

class TeamListCoordinator: NSObject {
    var childCoordinators: [CoordinatorType] = []
    
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        let moduleInput = TeamListViewModel.ModuleInput(coordinator: self)
        let moduleData = TeamListViewModel.ModuleInputData()
        let configurator = TeamListConfigurator.module(inputData: moduleData, moduleInput: moduleInput)
        if let viewCtrl = configurator?.0 {
            self.navigationController.pushViewController(viewCtrl, animated: false)
        }
    }
}

extension TeamListCoordinator: TeamListCoordinatorType {
    func showTeam(_ team: Team) {
        let moduleInput = TeamDetailViewModel.ModuleInput(coordinator: self)
        let moduleData = TeamDetailViewModel.ModuleInputData(team: team)
        if let module = TeamDetailConfigurator.module(inputData: moduleData,
                                                      moduleInput: moduleInput) {
            self.navigationController.pushViewController(module.0, animated: true)
        }
    }
}

extension TeamListCoordinator: TeamDetailCoordinatorType {
    func presentWebView(page: String) {
        let webCtrl = TOWebViewController(urlString: page)
        self.navigationController.pushViewController(webCtrl, animated: true)
    }
}

extension TeamListCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        guard let fromVC = navigationController
            .transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        if navigationController.viewControllers.contains(fromVC) {
            return
        }
        if fromVC is TeamDetailViewController {
        }
    }
}
