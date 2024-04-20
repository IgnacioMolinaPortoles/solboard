//
//  AssetsService.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 11/04/2024.
//

import Foundation

struct AssetViewModel {
    var id = UUID().uuidString
    
    var address: String?
    var pricePerToken: Double?
    var balance: Decimal?
    var name: String?
    var symbol: String?
    var tokenType: TokenType
    var metadata: AssetMetadata?
    var image: String?
    var onAssetDetailTap: (() -> Void)?
}

extension AssetViewModel {
    init(from item: AssetItem) {
        let symbol = item.content?.metadata?.symbol ?? ""
        
        if let info = item.tokenInfo, item.content?.metadata?.tokenStandard == .fungible {
            let name = item.content?.metadata?.name
            let imageUrl = item.content?.files?.first?.uri
            let image = name?.lowercased() == "wrapped sol" ? "https://assets.coingecko.com/coins/images/4128/standard/solana.png?1696504756" : imageUrl
            let balance = Decimal(info.balance ?? 0)
            let decimals = pow(10, info.decimals ?? 0)
            let realBalance = balance / decimals
            
            self.init(address: item.id,
                      pricePerToken: info.priceInfo?.pricePerToken ?? 0.0,
                      balance: realBalance,
                      name: item.content?.metadata?.name,
                      symbol: name?.lowercased() == "wrapped sol" ? "Wrapped SOL" : symbol,
                      tokenType: .fungible,
                      metadata: item.content?.metadata,
                      image: image,
                      onAssetDetailTap: nil)
        } else {
            self.init(address: item.id,
                      pricePerToken: 0,
                      balance: Decimal(item.tokenInfo?.balance ?? 1),
                      name: item.content?.metadata?.name,
                      symbol: symbol,
                      tokenType: .nonFungible,
                      metadata: item.content?.metadata,
                      image: item.content?.files?.first?.uri,
                      onAssetDetailTap: nil)
        }
    }
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
        return map(response?.result?.items ?? [], onAssetDetailTap: nil)
    }
    
    static func map(_ items: [AssetItem], onAssetDetailTap: (() -> Void)?) -> [AssetViewModel] {
        var assetsViewModel: [AssetViewModel] = []
        
        items.forEach({ item in
            guard let symbol = item.content?.metadata?.symbol else {
                return
            }
            
            assetsViewModel.append(AssetViewModel(from: item))
        })
        
        return assetsViewModel
    }
}
