//
//  TokenViewModel.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 14/04/2024.
//

import Foundation

enum TokenType: String, CaseIterable, Codable {
    case fungible = "Fungible"
    case nonFungible = "NonFungible"
    
    var displayableName: String {
        switch self {
        case .fungible: return "Tokens"
        case .nonFungible: return "NFTs"
        }
    }
    
    var hexColor: String {
        switch self {
        case .fungible: return "00EAE2"
        case .nonFungible: return "FF4500"
        }
    }
    
    var sortOrder: Int {
        switch self {
        case .fungible:
            return 0
        case .nonFungible:
            return 1
        }
    }
}

struct TokenViewModel: Identifiable, Comparable {
    static func < (lhs: TokenViewModel, rhs: TokenViewModel) -> Bool {
        return lhs.tokenType.sortOrder < rhs.tokenType.sortOrder
    }
    
    var id: String = UUID().uuidString
    
    var tokenName: String
    var tokenType: TokenType
}
