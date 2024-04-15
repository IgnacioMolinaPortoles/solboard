//
//  Coordinator.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 26/03/2024.
//

import Foundation
import UIKit
import CoreData

protocol TransactionRouting: AnyObject {
    func routeToTransactionDetail(tx: String)
}

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
        guard let context = UIApplication.appDelegate?.persistentContainer.viewContext else {
            return
        }
        let validatorService = ValidatorService()
        let coreDataManager = UserCoreDataManager(context: context)
        let serviceDecotared = PersistenceDecoratorForValidatorService(validatorService: validatorService,
                                                                       coreDataManager: coreDataManager)

        let vm = ImportWalletViewModel(validatorService: serviceDecotared)
        let vc = ImportWalletViewController(viewModel: vm, coordinator: self, alertManager: AlertManager())
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func buildHome() {
        navigationController.viewControllers.removeAll()
        
        let vc = TabbarController(tabs: [HomeCoordinator(navigationController: UINavigationController())])
        guard let sceneDelegate = UIApplication.sceneDelegate else { return }
        sceneDelegate.setRootViewController(vc)
    }
}

class HomeCoordinator: Coordinator, TransactionRouting {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = HomeViewController(coordinator: self)
        vc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func routeToTransactionDetail(tx: String) {
        guard let url = URL(string: "https://solscan.io/tx/"+tx) else { return }
        UIApplication.shared.open(url)
    }
}
