//
//  SolanaPriceResponse.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 13/04/2024.
//

import Foundation

struct SolanaPriceResponse: Codable {
    let data: GetSignaturesData?
    let timeTaken: Double?
}

// MARK: - GetSignaturesData
struct GetSignaturesData: Codable {
    let sol: GetSignaturesSol?

    enum CodingKeys: String, CodingKey {
        case sol = "SOL"
    }
}

// MARK: - GetSignaturesSol
struct GetSignaturesSol: Codable {
    let id, mintSymbol, vsToken, vsTokenSymbol: String?
    let price: Double?
}
