//
//  Coordinator.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 26/03/2024.
//

import Foundation
import UIKit

protocol ImportingWallet: AnyObject {
    func importWallet()
}

protocol HomeBuilding: AnyObject {
    func buildHome()
}

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

class LoginCoordinator: Coordinator, ImportingWallet, HomeBuilding {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = SplashScreenViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func importWallet() {
        let vc = ImportWalletViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func buildHome() {
        navigationController.viewControllers.removeAll()
        
        let vc = TabbarController()
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        sceneDelegate.setRootViewController(vc)
    }
}

class HomeCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = HomeViewController()
        vc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        navigationController.pushViewController(vc, animated: false)
    }
}
