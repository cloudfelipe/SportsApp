//
//  InitialRouter.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright © 2018 Test CondorLabs LTD. All rights reserved.
//

import UIKit
import RxSwift

protocol InitialRouterInput {
    func presentTeamList()
}

class InitialRouter {
    weak var viewController: UIViewController!
    
    private let disposeBag = DisposeBag()
    
    var navigationController: UINavigationController? {
        return self.viewController.navigationController
    }
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Navigation methods
    
    func push(viewController: UIViewController, animated: Bool) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(viewController, animated: animated)
        }
    }
    
    func pop(animated: Bool) {
        // navigate here
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: animated)
        }
    }
    
    private func present(viewController: UIViewController, withNavigationCtrl navigation: Bool = false) {
        var ctrlToShow = viewController //The controller to be shown
        if navigation { //if is needed to create a nav ctrl, enters here
            let navCtrl = UINavigationController(rootViewController: viewController)
            ctrlToShow = navCtrl
        }
        DispatchQueue.main.async {
            self.viewController.present(ctrlToShow, animated: true, completion: nil)
        }
    }
    
    func dismiss(animated: Bool) {
        DispatchQueue.main.async {
            self.viewController.dismiss(animated: animated, completion: nil)
        }
    }
}

extension InitialRouter: InitialRouterInput {
    func presentTeamList() {
        let configurator = TeamListConfigurator.module(inputData: TeamListViewModel.ModuleInputData())
        if let viewCtrl = configurator?.0 {
            self.present(viewController: viewCtrl, withNavigationCtrl: true)
        }
    }
}
