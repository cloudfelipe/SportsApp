//
//  InitialConfigurator.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright (c) 2018 Test CondorLabs LTD. All rights reserved.
//

import UIKit

class InitialConfigurator {
    class func configure(inputData: InitialViewModel.ModuleInputData,
                         moduleInput: InitialViewModel.ModuleInput? = nil) throws
        -> (viewController: UIViewController, moduleOutput: InitialViewModel.ModuleOutput) {
            // View controller
            let viewController = createViewController()
            let router = InitialRouter(viewController: viewController)
            
            // Dependencies
            let dependencies = try createDependencies(router: router)
            
            // View model
            let viewModel = InitialViewModel(dependencies: dependencies, moduleInputData: inputData)
            let moduleOutput = viewModel.configureModule(input: moduleInput)
            
            viewController.viewModel = viewModel
            
            return (viewController, moduleOutput)
    }
    
    private class func createViewController() -> InitialViewController {
        return InitialViewController()
    }
    
    private class func createDependencies(router: InitialRouterInput) throws -> InitialViewModel.InputDependencies {
        let dependencies =
            InitialViewModel.InputDependencies(initialRouter: router)
        return dependencies
    }
    
    static func module(
        inputData: InitialViewModel.ModuleInputData,
        moduleInput: InitialViewModel.ModuleInput? = nil)
        -> (UIViewController, InitialViewModel.ModuleOutput)? {
            do {
                let output = try InitialConfigurator.configure(inputData: inputData, moduleInput: moduleInput)
                return (output.viewController, output.moduleOutput)
            } catch let err {
                print(err)
                return nil
            }
    }
}
