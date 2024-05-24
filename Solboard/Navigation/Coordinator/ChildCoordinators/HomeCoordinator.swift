//
//  HomeCoordinator.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 23/04/2024.
//

import SwiftUI
import UIKit
import Foundation

protocol LogoutRouting: AnyObject {
    func logout()
}

protocol SettingsRouting: AnyObject {
    func routeToSettings()
}

protocol TransactionRouting: AnyObject {
    func routeToTransactionDetail(tx: String)
    func routeToAllTransactions(txs: [TransactionViewModel])
}

protocol AssetRouting {
    func routeToAssetView(assets: [AssetItem])
}

class HomeCoordinator: Coordinator, TransactionRouting, AssetRouting, SettingsRouting, LogoutRouting {
    
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    var uiApplication: UIApplicationURLRouterProtocol
    var dataManager: any UserPersistenceProtocol
    
    init(navigationController: UINavigationController,
         uiApplication: UIApplicationURLRouterProtocol = UIApplication.shared,
         dataManager: any UserPersistenceProtocol) {
        self.navigationController = navigationController
        self.uiApplication = uiApplication
        self.dataManager = dataManager
    }
    
    func start() {
        let vm = HomeViewModel(assetServiceManager: AssetsServiceManager(assetsService: AssetsService()),
                                                      transactionsService: TransactionsService(),
                                                      dataManager: dataManager)
        let vc = HomeViewController(viewModel: vm, coordinator: self)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func logout() {
        navigationController.viewControllers.removeAll()
        
        let vc = LoginCoordinator(navigationController: UINavigationController(),
                                                dataManager: dataManager)
        
        vc.start()
        
        guard let sceneDelegate = UIApplication.sceneDelegate else { return }
        sceneDelegate.setRootViewController(vc.navigationController)
    }
    
    func routeToSettings() {
        let vm = SettingsViewModel(dataManager: dataManager as! UserCoreDataManager,
                                   validatorService: ValidatorService(),
                                   alertManager: AlertManager(),
                                   coordinator: self)
        
        let vc = UIHostingController(rootView: SettingsView(vm: vm))
        navigationController.present(vc, animated: true)
    }
    
    func routeToTransactionDetail(tx: String) {
        let vm = TransactionDetailViewModel(transactionService: TransactionsService(),
                                            signature: tx, onTransactionTapDo: {
            guard let topVC = self.navigationController.topViewController else { return }
            topVC.copyToClipboard(tx)
        })
        
        let vc = UIHostingController(rootView: TransactionDetailView(vm: vm))
        self.navigationController.pushViewController(vc,
                                                animated: true)
    }
    
    func routeToAllTransactions(txs: [TransactionViewModel]) {
        let vm = TransactionsListViewModel(transactions: txs, 
                                           searchBarEnabled: true)
        let transactionsView = TransactionsList(vm: vm, onTransactionDetailTapDo: { [weak self] tx in
            self?.routeToTransactionDetail(tx: tx)
        })
        let vc = UIHostingController(rootView: transactionsView)
        vc.navigationItem.title = "Transaction list"
        navigationController.pushViewController(vc, animated: true)
    }
    
    func routeToAssetView(assets: [AssetItem]) {
        let assetsVMArray = assets.toAssetViewModel(onTap: { [weak self] assetItem in
            guard let self else { return }
            self.onAssetDetailTap(item: assetItem)
        })
        
        let vm = AssetsListViewModel(tokens: assetsVMArray)
        let vc = UIHostingController(rootView: AssetsListView(viewModel: vm))
        navigationController.pushViewController(vc,
                                                animated: true)
    }
    
    func onAssetDetailTap(item: AssetItem) {
        let vc = UIHostingController(rootView: DetailsView(detailItem: DetailItemViewModel(from: item, goToWeb: { [weak self] in
            guard let self else { return }
            self.routeToWeb(item: item)
        }, copyAddressToClipboard: {
            guard let topVC = self.navigationController.topViewController else { return }
            topVC.copyToClipboard(item.id)
        })))
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func routeToWeb(item: AssetItem) {
        guard let id = item.id,
              let url: URL = item.isFungible() ?
                URL(string: "https://solscan.io/token/\(id)") :
                URL(string: "https://magiceden.io/item-details/\(id)")
        else {
            return
        }
        
        self.goTo(url: url)
    }
}

extension HomeCoordinator {
    func goTo(url: URL) {
        if self.uiApplication._canOpenURL(url) {
            self.uiApplication._open(url, options: [:], completionHandler: nil)
        }
    }
}
