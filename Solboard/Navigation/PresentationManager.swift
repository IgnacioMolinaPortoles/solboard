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
    private let homeCoordinator: Coordinator
    
    init(dataManager: any UserPersistenceProtocol,
         loginCoordinator: Coordinator,
         homeCoordinator: Coordinator) {
        self.dataManager = dataManager
        self.loginCoordinator = loginCoordinator
        self.homeCoordinator = homeCoordinator
    }
    
    func getNavigation() -> UIViewController {
        guard dataManager.getUser() != nil else {
            self.loginCoordinator.start()
            return self.loginCoordinator.navigationController
        }
        
        self.homeCoordinator.start()
        return self.homeCoordinator.navigationController
    }
}
