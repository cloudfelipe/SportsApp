//
//  TeamListConfigurator.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright (c) 2018 Test CondorLabs LTD. All rights reserved.
//

import UIKit

class TeamListConfigurator {
    class func configure(inputData: TeamListViewModel.ModuleInputData,
                         moduleInput: TeamListViewModel.ModuleInput? = nil) throws
        -> (viewController: UIViewController, moduleOutput: TeamListViewModel.ModuleOutput) {
            // View controller
            let viewController = createViewController()
            let router = TeamListRouter(viewController: viewController)
            // Dependencies
            let dependencies = try createDependencies(router: router)
            
            // View model
            let viewModel = TeamListViewModel(dependencies: dependencies, moduleInputData: inputData)
            let moduleOutput = viewModel.configureModule(input: moduleInput)
            
            viewController.viewModel = viewModel
            
            return (viewController, moduleOutput)
    }
    
    private class func createViewController() -> TeamListViewController {
        return TeamListViewController()
    }
    
    private class func createDependencies(router: TeamListRouterInput) throws -> TeamListViewModel.InputDependencies {
        let teamServices = TeamServices()
        let dependencies = TeamListViewModel.InputDependencies(router: router,
                                                               teamServices: teamServices)
        return dependencies
    }
    
    static func module(
        inputData: TeamListViewModel.ModuleInputData,
        moduleInput: TeamListViewModel.ModuleInput? = nil)
        -> (UIViewController, TeamListViewModel.ModuleOutput)? {
            do {
                let output = try TeamListConfigurator.configure(inputData: inputData, moduleInput: moduleInput)
                return (output.viewController, output.moduleOutput)
            } catch let err {
                print(err)
                return nil
            }
    }
}
