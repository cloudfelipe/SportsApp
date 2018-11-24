//
//  BaseRouter.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright © 2018 Test CondorLabs LTD. All rights reserved.
//

import UIKit
import RxSwift

/// Class used as base for all routers
/// This class is responsible for coordinate the controller's navigation flow
class BaseRouter {
    weak var viewController: UIViewController!
    
    let disposeBag = DisposeBag()
    
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
    
    func present(viewController: UIViewController, withNavigationCtrl navigation: Bool = false) {
        var ctrlToShow = viewController //The controller to be shown
        if navigation { //if is needed to create a nav ctrl, enters here
            let navCtrl = UINavigationController(rootViewController: viewController)
            navCtrl.navigationBar.isTranslucent = false
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
