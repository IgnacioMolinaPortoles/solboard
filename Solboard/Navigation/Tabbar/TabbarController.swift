//
//  TabbarController.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 26/03/2024.
//

import Foundation
import UIKit

class TabbarController: UITabBarController {
    private let tabs: [Coordinator]
    
    init(tabs: [Coordinator]) {
        self.tabs = tabs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for tab in tabs {
            tab.start()
        }
        
        viewControllers = tabs.map({ Coordinator in
            return Coordinator.navigationController
        })
    }
}
