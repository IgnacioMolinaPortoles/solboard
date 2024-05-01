//
//  AssetItemViewModel.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 23/04/2024.
//

import Foundation

struct AssetItemViewModel: Equatable {
    var id = UUID().uuidString
    
    var address: String?
    var pricePerToken: Double?
    var balance: Double?
    var name: String?
    var symbol: String?
    var tokenType: TokenType
    var metadata: AssetMetadata?
    var image: String?
    var onAssetDetailTap: (() -> Void)?
    
    static func == (lhs: AssetItemViewModel, rhs: AssetItemViewModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension [AssetItemViewModel] {
    func toTokenViewModel() -> [TokenViewModel] {
        var viewModel = self.compactMap { asset in
            if let name = asset.name ?? asset.symbol, !name.isEmpty {
                return TokenViewModel(tokenName: name,
                               tokenType: asset.tokenType)
            }
            return nil
        }

        viewModel.sort { $0.tokenType.sortOrder < $1.tokenType.sortOrder }
        
        return viewModel
    }
}

extension AssetItemViewModel {
    init(from item: AssetItem) {
        let metadataSymbol = item.content?.metadata?.symbol
        let tokenInfoSymbol = item.tokenInfo?.symbol
        
        let symbol = metadataSymbol ?? tokenInfoSymbol ?? ""
        let tokenStandard = item.content?.metadata?.tokenStandard?.lowercased()
        let interface = item.interface ?? ""
        
        if let info = item.tokenInfo, (tokenStandard == TokenType.fungible.rawValue.lowercased() || interface == "FungibleToken") {
            let name = item.content?.metadata?.name
            let imageUrl = item.content?.files?.first?.uri
            let image = name?.lowercased() == "wrapped sol" ? "https://assets.coingecko.com/coins/images/4128/standard/solana.png?1696504756" : imageUrl
            let balance = info.balance ?? 0
            let decimals = pow(10, info.decimals ?? 0).doubleValue
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
                      balance: item.tokenInfo?.balance ?? 1,
                      name: item.content?.metadata?.name,
                      symbol: symbol,
                      tokenType: .nonFungible,
                      metadata: item.content?.metadata,
                      image: item.content?.files?.first?.uri,
                      onAssetDetailTap: nil)
        }
    }
}
