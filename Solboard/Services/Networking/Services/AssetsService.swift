//
//  AssetsService.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 11/04/2024.
//

import Foundation

struct AssetViewModel {
    var assetAddress: String?
    var pricePerToken: Double?
    var balance: Decimal?
    var name: String?
    var tokenType: TokenType
    var metadata: String?
}

extension [AssetViewModel] {
    func toTokenViewModel() -> [TokenViewModel] {
        var viewModel = self.map { asset in
            TokenViewModel(tokenName: asset.name ?? "",
                           tokenType: asset.tokenType)
        }

        viewModel.sort { $0.tokenType.sortOrder < $1.tokenType.sortOrder }
        
        return viewModel
    }
}

protocol AssetsServiceProtocol {
    func getAddressAssets(_ address: String, completion: @escaping (AssetByOwnerResponse?) -> Void)
    func getSolanaPrice(completion: @escaping (Double) -> Void)
    func getBalance(_ address: String, completion: @escaping (Double) -> Void)
}
    
final class AssetsService: AssetsServiceProtocol {
    private let client: HTTPClient
    
    init(client: HTTPClient = URLSession.shared) {
        self.client = client
    }
    
    func getBalance(_ address: String, completion: @escaping (Double) -> Void) {
        guard let request = RPCMethods.getBalance(address).buildRequest(node: .helius) else {
            completion(0.0)
            return
        }
        
        client.perform(request, timeout: 10) { jsonData, response, error in
            guard let jsonData else {
                completion(0.0)
                return
            }
            
            let response = try? JSONDecoder().decode(GetBalanceResponse.self, from: jsonData)
            
            if let solBalance = response?.result?.value {
                completion(Double(solBalance / 1000000000))
            } else {
                completion(0.0)
            }
        }
    }
    
    func getSolanaPrice(completion: @escaping (Double) -> Void) {
        guard let request = RPCMethods.getSolanaPrice.buildRequest(node: .coinGecko) else {
            completion(0.0)
            return
        }
        
        client.perform(request, timeout: 10) { jsonData, response, error in
            guard let jsonData else {
                completion(0.0)
                return
            }
            
            let response = try? JSONDecoder().decode(SolanaPriceResponse.self, from: jsonData)
            completion(response?.solana?.usd ?? 0.0)
        }
    }
    
    func getAddressAssets(_ address: String, completion: @escaping (AssetByOwnerResponse?) -> Void) {
        guard let request = RPCMethods.getAssetsByOwner(address).buildRequest(node: Node.helius) else {
            completion(nil)
            return
        }
        
        client.perform(request, timeout: TimeInterval(floatLiteral: 10.0)) { jsonData, response, error  in
            guard let jsonData else {
                completion(nil)
                return
            }
            let assetWelcome = try? JSONDecoder().decode(AssetByOwnerResponse.self, from: jsonData)
            completion(assetWelcome)
        }
    }
}

struct AssetsMapper {
    static func map(response: AssetByOwnerResponse?) -> [AssetViewModel] {
        var assetsViewModel: [AssetViewModel] = []
        
        response?.result?.items?.forEach({ item in
            if let info = item.tokenInfo {
                let balance = Decimal(info.balance ?? 0)
                let decimals = pow(10, info.decimals ?? 0)
                let realBalance = balance / decimals
                
                let asset = AssetViewModel(assetAddress: item.id,
                                           pricePerToken: info.priceInfo?.pricePerToken ?? 0.0,
                                           balance: realBalance,
                                           name: item.content?.metadata?.name,
                                           tokenType: .fungible,
                                           metadata: item.content?.jsonURI)
                
                assetsViewModel.append(asset)
            } else {
                let asset = AssetViewModel(assetAddress: item.id,
                                           pricePerToken: 0,
                                           balance: 1,
                                           name: item.content?.metadata?.name,
                                           tokenType: .nonFungible,
                                           metadata: item.content?.jsonURI)
                assetsViewModel.append(asset)
            }
        })
        
        return assetsViewModel
    }
}
