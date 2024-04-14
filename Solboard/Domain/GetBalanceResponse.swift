//
//  GetBalanceResponse.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 13/04/2024.
//

import Foundation

// MARK: - GetBalanceResponse
struct GetBalanceResponse: Codable {
    let jsonrpc: String?
    let result: GetBalanceResult?
    let id: Int?
}

// MARK: - GetBalanceResponseResult
struct GetBalanceResult: Codable {
    let context: GetBalanceContext?
    let value: Int?
}

// MARK: - GetBalanceResponseContext
struct GetBalanceContext: Codable {
    let apiVersion: String?
    let slot: Int?
}
