//
//  DetailItemViewModel.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 05/05/2024.
//

import Foundation

struct DetailItemViewModel: Identifiable {
    var id: String
    var name: String
    var description: String
    var imageUrl: URL
    var address: String
    var royaltyFee: Double
    var attributes: [AssetAttribute]
    var pricePerToken: Double
    var balance: Double
    var goToWebString: String
    var goToWeb: () -> Void
    
    var formattedBalance: String {
        String(format: "%.2f", balance)
    }
    
    func formatNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 16
        return formatter.string(from: NSNumber(value: number)) ?? "0.00"
    }
    
    var formattedPricePerToken: String {
        String(format: "%.2f", pricePerToken) == "0.00" ?
        "$\(formatNumber(pricePerToken))" :
        String(format: "$%.2f", pricePerToken)
    }
    
    var formattedTotalValue: String {
        let totalValue = balance * pricePerToken
        
        return String(format: "%.2f", totalValue) == "0.00" ?
        "$\(formatNumber(totalValue))" :
        String(format: "$%.2f", totalValue)
    }
    
    var formattedRoyaltyFee: String {
        String(format: "%.2f%%", royaltyFee * 100)
    }
    
    var formattedAddress: String {
        address.shortSignature
    }
}

extension DetailItemViewModel {
    init(from assetItem: AssetItem, goToWeb: @escaping () -> Void) {
        self.id = assetItem.id ?? ""
        
        self.name = assetItem.content?.metadata?.name ?? ""
        self.description = assetItem.content?.metadata?.description ?? ""
        
        if let imageUrlString = assetItem.content?.links?.image, let url = URL(string: imageUrlString) {
            self.imageUrl = url
        } else {
            self.imageUrl = URL(string: "https://assets.coingecko.com/coins/images/4128/standard/solana.png?1696504756")!
        }
        
        self.address = assetItem.id ?? ""
        
        if let royalty = assetItem.royalty {
            self.royaltyFee = royalty.percent ?? 0.0
        } else {
            self.royaltyFee = 0.0
        }
        
        self.attributes = []
        
        if let symbol = assetItem.content?.metadata?.symbol {
            self.attributes.append(AssetAttribute(value: AssetValue(symbol), traitType: "Symbol"))
        }
        
        if let attributes = assetItem.content?.metadata?.attributes {
            self.attributes.append(contentsOf: attributes)
        }
        
        self.pricePerToken = 0.0
        
        if let price = assetItem.tokenInfo?.priceInfo?.pricePerToken {
            self.pricePerToken = price
        }
        
        self.balance = 0.0
        
        if let balance = assetItem.tokenInfo?.balance, let decimals = assetItem.tokenInfo?.decimals {
            let decimalBalance = balance
            let decimals = pow(10, decimals).doubleValue
            let realBalance = decimalBalance / decimals
            
            self.balance = realBalance
        }
        
        self.goToWebString = assetItem.getInterface() == .fungible ? "View on Solscan" : "View on Magic Eden"
        self.goToWeb = goToWeb
    }
}
