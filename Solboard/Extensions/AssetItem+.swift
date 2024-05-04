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
        
        if let info = self.tokenInfo, (tokenStandard == TokenType.fungible.rawValue.lowercased() || interface == "FungibleToken") {
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
