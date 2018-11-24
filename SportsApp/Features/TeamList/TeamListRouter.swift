//
//  TeamListRouter.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright © 2018 Test CondorLabs LTD. All rights reserved.
//

import Foundation

protocol TeamListRouterInput {
    func showTeam(_ team: Team)
}

class TeamListRouter: BaseRouter, TeamListRouterInput {
    func showTeam(_ team: Team) {
        let configurator = TeamDetailConfigurator.module(inputData: TeamDetailViewModel.ModuleInputData())
        guard let viewCtrl = configurator?.0 else { return }
        self.push(viewController: viewCtrl, animated: true)
    }
}
