//
//  TeamListCoordinator.swift
//  SportsApp
//
//  Created by Felipe Correa on 5/15/19.
//  Copyright © 2019 Test CondorLabs LTD. All rights reserved.
//

import UIKit
import XCoordinator
import TOWebViewController

enum HomeRoute: Route {
    case teamList
    case teamDetail(Team)
    case presentWebView(String)
}

final class TeamListCoordinator: NavigationCoordinator<HomeRoute> {
    init() {
        super.init(initialRoute: .teamList)
        self.rootViewController.navigationBar.isTranslucent = false
    }
    override func prepareTransition(for route: HomeRoute) -> NavigationTransition {
        switch route {
        case .teamList:
            let moduleData = TeamListViewModel.ModuleInputData(router: anyRouter)
            let module = TeamListConfigurator.module(inputData: moduleData)
            let controller = module!.0
            return .show(controller)
        case .teamDetail(let team):
            let output: (TeamDetailViewModel.OutputModuleActionType) -> Void = { action in
                switch action {
                case .showWebpage(let url):
                    self.trigger(.presentWebView(url))
                }
            }
            let data = TeamDetailViewModel.ModuleInputData(team: team,
                                                           router: anyRouter,
                                                           action: output)
            let configurator = TeamDetailConfigurator.module(inputData: data)
            return .show(configurator!.0)
        case .presentWebView(let url):
            let webCtrl = TOWebViewController(urlString: url)
            return .show(webCtrl)
        }
    }
}
