//
//  TeamDetail+Structures.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright (c) 2018 Test CondorLabs LTD. All rights reserved.

import Foundation
import RxSwift
import XCoordinator

extension TeamDetailViewModel {
    
    enum OutputModuleActionType {
        case showWebpage(url: String)
    }
    
    // MARK: - initial module data
    struct ModuleInputData {
        let team: Team
        let router: AnyRouter<HomeRoute>
        let action: ((OutputModuleActionType) -> Void)
    }
    
    // MARK: - module input structure
    struct ModuleInput {
    }
    
    // MARK: - module output structure
    struct ModuleOutput {
        let moduleAction: Observable<OutputModuleActionType>
    }
}
