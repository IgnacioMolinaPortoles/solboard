//
//  LoginCoordinator.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 23/04/2024.
//

import Foundation
import UIKit

protocol ImportingWallet: AnyObject {
    func importWallet()
}

protocol HomeBuilding: AnyObject {
    func buildHome()
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
