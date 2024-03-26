//
//  TabbarController.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 26/03/2024.
//

import Foundation
import UIKit

class TabbarController: UITabBarController {
    let home = HomeCoordinator(navigationController: UINavigationController())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        home.start()
        viewControllers = [home.navigationController]
    }
}
