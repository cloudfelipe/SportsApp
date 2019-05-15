//
//  TeamList+Structures.swift
//  SportsApp
//
//  Created by Felipe Correa on 11/24/18.
//  Copyright (c) 2018 Test CondorLabs LTD. All rights reserved.

import Foundation
import RxSwift
import XCoordinator

extension TeamListViewModel {
    
    enum OutputModuleActionType {
        
    }
    
    // MARK: - initial module data
    struct ModuleInputData {
        let router: AnyRouter<HomeRoute>
    }
    
    // MARK: - module input structure
    struct ModuleInput {
    }
    
    // MARK: - module output structure
    struct ModuleOutput {
        let moduleAction: Observable<OutputModuleActionType>
    }
    
}
