//
//  LoginConfigurator.swift
//  SportsApp
//
//  Created by Felipe Correa on 5/15/19.
//  Copyright © 2019 Test CondorLabs LTD. All rights reserved.
//

import UIKit
import XCoordinator

class LoginConfigurator {
    class func configure(inputData: LoginViewModel.ModuleInputData,
                         moduleInput: LoginViewModel.ModuleInput? = nil) throws
        -> (viewController: UIViewController, moduleOutput: LoginViewModel.ModuleOutput) {
            // View controller
            let viewController = createViewController()
            
            // Dependencies
            let dependencies = try createDependencies(router: moduleInput?.router)
            
            // View model
            let viewModel = LoginViewModel(dependencies: dependencies, moduleInputData: inputData)
            let moduleOutput = viewModel.configureModule(input: moduleInput)
            
            viewController.viewModel = viewModel
            
            return (viewController, moduleOutput)
    }
    
    private class func createViewController() -> LoginViewController {
        return LoginViewController.instantiate(fromAppStoryboard: .Main)
    }
    
    private class func createDependencies(router: AnyRouter<AppRoute>?) throws -> LoginViewModel.InputDependencies {
        let dependencies =
            LoginViewModel.InputDependencies(router: router)
        return dependencies
    }
    
    static func module(
        inputData: LoginViewModel.ModuleInputData,
        moduleInput: LoginViewModel.ModuleInput? = nil)
        -> (UIViewController, LoginViewModel.ModuleOutput)? {
            do {
                let output = try LoginConfigurator.configure(inputData: inputData, moduleInput: moduleInput)
                return (output.viewController, output.moduleOutput)
            } catch let err {
                print(err)
                return nil
            }
    }
}
