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
}

protocol AssetRouting {
    func routeToAssetView(assets: [AssetItem])
}

class HomeCoordinator: Coordinator, TransactionRouting, AssetRouting {
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
    
    func routeToAssetView(assets: [AssetItem]) {
        let assetsVMArray = assets.compactMap { assetItem in
            let metadataSymbol = assetItem.content?.metadata?.symbol ?? ""
            let tokenInfoSymbol = assetItem.tokenInfo?.symbol ?? ""
            
            if !metadataSymbol.isEmpty || !tokenInfoSymbol.isEmpty {
                var assetVM = AssetItemViewModel(from: assetItem)
                assetVM.onAssetDetailTap = {
                    onAssetDetailTap(item: assetItem)
                }
                return assetVM
            }
            return nil
        }
        
        func onAssetDetailTap(item: AssetItem) {
            let vc = UIHostingController(rootView: DetailsView(nft: DetailItemViewModel(from: item)))
            self.navigationController.pushViewController(vc, animated: true)
        }
        
        let vm = AssetsListViewModel(tokens: assetsVMArray)
        let vc = UIHostingController(rootView: AssetsListView(viewModel: vm))
        navigationController.pushViewController(vc,
                                                animated: true)
    }
}
