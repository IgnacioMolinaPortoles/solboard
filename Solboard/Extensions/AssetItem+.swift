//
//  AssetItem+.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 04/05/2024.
//

import Foundation

extension AssetItem {
    func getInterface() -> TokenType {
        let tokenStandard = self.content?.metadata?.tokenStandard?.lowercased()
        let interface = self.interface ?? ""
        
        if let _ = self.tokenInfo, (tokenStandard == TokenType.fungible.rawValue.lowercased() || interface == "FungibleToken") {
            return .fungible
        }
        return .nonFungible
    }
    
    func isFungible() -> Bool {
        self.getInterface() == .fungible
    }
    
    func getSymbol() -> String? {
        let metadataSymbol = self.content?.metadata?.symbol
        let tokenInfoSymbol = self.tokenInfo?.symbol
        
        return metadataSymbol ?? tokenInfoSymbol
    }
}

extension [AssetItem] {
    func toAssetViewModel(onTap: @escaping (AssetItem) -> Void) -> [AssetItemViewModel] {
        return self.compactMap { assetItem in
            let metadataSymbol = assetItem.content?.metadata?.symbol ?? ""
            let tokenInfoSymbol = assetItem.tokenInfo?.symbol ?? ""
            
            if !metadataSymbol.isEmpty || !tokenInfoSymbol.isEmpty {
                var assetVM = AssetItemViewModel(from: assetItem)
                assetVM.onAssetDetailTap = {
                    onTap(assetItem)
                }
                return assetVM
            }
            return nil
        }
    }
}
