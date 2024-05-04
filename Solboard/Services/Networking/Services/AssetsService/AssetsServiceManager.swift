//
//  AssetsServiceManager.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 23/04/2024.
//

import Foundation

protocol AssetsServiceManagerProtocol {
    func getAssets(completion: @escaping ([AssetItem]) -> Void)
}

final class AssetsServiceManager: AssetsServiceManagerProtocol {
    private let assetsService: AssetsServiceProtocol
    
    init(assetsService: AssetsServiceProtocol) {
        self.assetsService = assetsService
    }
    
    func getAssets(completion: @escaping ([AssetItem]) -> Void) {
        var assetsItems: [AssetItem] = []
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        
        DispatchQueue.global().sync { [weak self] in
            self?.assetsService.getAddressAssets(address) { response in
                assetsItems.append(contentsOf: response?.result?.items ?? [])
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        DispatchQueue.global().sync { [weak self] in
            self?.assetsService.getSolanaPrice() { price in
                self?.assetsService.getBalance(address) { solBalance in
                    assetsItems.append(AssetItem(id: "So11111111111111111111111111111111111111112",
                                                 pricePerToken: price,
                                                 balance: solBalance * 10000000000,
                                                 name: "Solana",
                                                 symbol: "SOL",
                                                 tokenType: .fungible,
                                                 image: "https://assets.coingecko.com/coins/images/4128/standard/solana.png?1696504756"))
                    dispatchGroup.leave()
                }
            }
        }
        
        
        dispatchGroup.notify(queue: .main) {
            completion(assetsItems)
        }
    }
}
