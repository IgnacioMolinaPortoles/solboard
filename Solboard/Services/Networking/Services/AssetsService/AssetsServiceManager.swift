//
//  AssetsServiceManager.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 23/04/2024.
//

import Foundation

protocol AssetsServiceManagerProtocol {
    func getAssets(_ address: String, completion: @escaping ([AssetItem]) -> Void)
}

final class AssetsServiceManager: AssetsServiceManagerProtocol {
    private let assetsService: AssetsServiceProtocol
    
    init(assetsService: AssetsServiceProtocol) {
        self.assetsService = assetsService
    }
    
    func getAssets(_ address: String, completion: @escaping ([AssetItem]) -> Void) {
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
                                                 balance: solBalance * Constants.lamports,
                                                 name: "Solana",
                                                 symbol: "SOL",
                                                 tokenType: .fungible,
                                                 image: Constants.solanaImageURL,
                                                 description: "Solana is a blockchain built for mass adoption. It's a high performance network that is utilized for a range of use cases, including finance, payments, and gaming. Solana operates as a single global state machine, and is open, interoperable, and decentralized."))
                    dispatchGroup.leave()
                }
            }
        }
        
        
        dispatchGroup.notify(queue: .main) {
            completion(assetsItems)
        }
    }
}
