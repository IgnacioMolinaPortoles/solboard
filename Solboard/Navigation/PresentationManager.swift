//
//  PresentationManager.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 28/03/2024.
//

import Foundation
import UIKit


class PresentationManager {
    
    private let dataManager: any UserPersistenceProtocol
    private let loginCoordinator: Coordinator
    private let tabsCoordinators: [Coordinator]
    
    init(dataManager: any UserPersistenceProtocol,
         loginCoordinator: Coordinator,
         tabsCoordinators: [Coordinator]) {
        self.dataManager = dataManager
        self.loginCoordinator = loginCoordinator
        self.tabsCoordinators = tabsCoordinators
    }
    
    func getNavigation() -> UIViewController {
        guard let user = dataManager.getUser() else {
            let loginCoordinator = self.loginCoordinator
            loginCoordinator.start()
            return loginCoordinator.navigationController
        }
        
        let homeVC = TabbarController(tabs: self.tabsCoordinators)
        return homeVC
    }
}
