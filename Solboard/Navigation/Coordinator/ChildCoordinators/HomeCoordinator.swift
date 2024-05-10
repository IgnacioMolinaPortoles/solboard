//
//  HomeCoordinator.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 23/04/2024.
//

import SwiftUI
import UIKit
import Foundation

protocol TransactionRouting: AnyObject {
    func routeToTransactionDetail(tx: String)
    func routeToAllTransactions(txs: [TransactionViewModel])
}

protocol AssetRouting {
    func routeToAssetView(assets: [AssetItem])
}

class HomeCoordinator: Coordinator, TransactionRouting, AssetRouting {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    var uiApplication: UIApplicationURLRouterProtocol
    
    init(navigationController: UINavigationController,
         uiApplication: UIApplicationURLRouterProtocol = UIApplication.shared) {
        self.navigationController = navigationController
        self.uiApplication = uiApplication
    }
    
    func start() {
        let vc = HomeViewController(coordinator: self)
        vc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func routeToTransactionDetail(tx: String) {
        let vm = TransactionDetailViewModel(transactionService: TransactionsService(),
                                            signature: tx)
        let vc = UIHostingController(rootView: TransactionDetailView(vm: vm))
        self.navigationController.pushViewController(vc,
                                                animated: true)
    }
    
    func routeToAllTransactions(txs: [TransactionViewModel]) {
        let vm = TransactionsListViewModel(transactions: txs)
        let transactionsView = TransactionsList(transactionsViewModel: vm, onTransactionDetailTapDo: { [weak self] tx in
            self?.routeToTransactionDetail(tx: tx)
            print(tx)
        }, tableTitle: "Transactions")
        let vc = UIHostingController(rootView: transactionsView)
        navigationController.pushViewController(vc, animated: false)
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
        let vc = UIHostingController(rootView: DetailsView(nft: DetailItemViewModel(from: item, goToWeb: { [weak self] in
            guard let self else { return }
            self.routeToWeb(item: item)
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
