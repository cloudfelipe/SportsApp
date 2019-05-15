//
//  CoordinatorType.swift
//  SportsApp
//
//  Created by Felipe Correa on 5/14/19.
//  Copyright © 2019 Test CondorLabs LTD. All rights reserved.
//

import UIKit

protocol CoordinatorType: AnyObject {
    var childCoordinators: [CoordinatorType] { get set }
    var navigationController: UINavigationController { get set}
    
    init (navigationController: UINavigationController)
    func start()
}
