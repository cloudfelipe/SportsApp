//
//  TeamListRouter.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright © 2018 Test CondorLabs LTD. All rights reserved.
//

import Foundation
import DZNWebViewController
import TOWebViewController

protocol TeamListRouterInput {
    func showTeam(_ team: Team)
    func presentWebView(page: String)
}

class TeamListRouter: BaseRouter, TeamListRouterInput {
    func showTeam(_ team: Team) {
        let configurator = TeamDetailConfigurator.module(inputData: TeamDetailViewModel.ModuleInputData(team: team))
        
        //Subscribe to detailCtrl's action responses
        configurator?.1.moduleAction
            .subscribe(onNext: { [unowned self] (actionType) in
                switch actionType {
                case .showWebpage(let url):
                    self.presentWebView(page: url)
                }
            }).disposed(by: disposeBag)
        
        guard let viewCtrl = configurator?.0 else { return }
        self.push(viewController: viewCtrl, animated: true)
    }
    
    func presentWebView(page: String) {
        let webCtrl = TOWebViewController(urlString: page)
        self.present(viewController: webCtrl, withNavigationCtrl: true)
    }
}
