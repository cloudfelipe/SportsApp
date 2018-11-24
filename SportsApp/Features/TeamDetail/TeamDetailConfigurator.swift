//
//  TeamDetailConfigurator.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright (c) 2018 Test CondorLabs LTD. All rights reserved.
//

import UIKit

class TeamDetailConfigurator {
    class func configure(inputData: TeamDetailViewModel.ModuleInputData,
                         moduleInput: TeamDetailViewModel.ModuleInput? = nil) throws
        -> (viewController: UIViewController, moduleOutput: TeamDetailViewModel.ModuleOutput) {
            // View controller
            let viewController = createViewController()
            
            // Dependencies
            let dependencies = try createDependencies()
            
            // View model
            let viewModel = TeamDetailViewModel(dependencies: dependencies, moduleInputData: inputData)
            let moduleOutput = viewModel.configureModule(input: moduleInput)
            
            viewController.viewModel = viewModel
            
            return (viewController, moduleOutput)
    }
    
    private class func createViewController() -> TeamDetailViewController {
        return TeamDetailViewController.instantiate(fromAppStoryboard: .Main)
    }
    
    private class func createDependencies() throws -> TeamDetailViewModel.InputDependencies {
        let dependencies =
            TeamDetailViewModel.InputDependencies(teamServices: TeamServices())
        return dependencies
    }
    
    static func module(
        inputData: TeamDetailViewModel.ModuleInputData,
        moduleInput: TeamDetailViewModel.ModuleInput? = nil)
        -> (UIViewController, TeamDetailViewModel.ModuleOutput)? {
            do {
                let output = try TeamDetailConfigurator.configure(inputData: inputData, moduleInput: moduleInput)
                return (output.viewController, output.moduleOutput)
            } catch let err {
                print(err)
                return nil
            }
    }
}
