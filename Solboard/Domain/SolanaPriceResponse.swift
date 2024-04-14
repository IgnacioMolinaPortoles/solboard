//
//  SolanaPriceResponse.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 13/04/2024.
//

import Foundation

struct SolanaPriceResponse: Codable {
    let solana: SolanaPriceResponseSolana?
}

// MARK: - SolanaPriceResponseEthereum
struct SolanaPriceResponseSolana: Codable {
    let usd: Double?
}
