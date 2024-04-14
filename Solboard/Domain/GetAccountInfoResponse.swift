//
//  GetAccountInfoDomain.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 03/04/2024.
//

import Foundation

struct GetAccountInfoResponse: Codable {
    let jsonrpc: String?
    let error: GetAccountInfoError?
    let result: GetAccountInfoResult?
    let id: Int?
}

// MARK: - GetAccountInfoError
struct GetAccountInfoError: Codable {
    let code: Int?
    let message: String?
}

// MARK: - GetAccountInfoResult
struct GetAccountInfoResult: Codable {
    let context: GetAccountInfoContext?
    let value: GetAccountInfoValue?
}

// MARK: - GetAccountInfoContext
struct GetAccountInfoContext: Codable {
    let apiVersion: String?
    let slot: Int?
}

// MARK: - GetAccountInfoValue
struct GetAccountInfoValue: Codable {
    let data: [String]?
    let executable: Bool?
    let lamports: Int?
    let owner: String?
    let rentEpoch: Double?
    let space: Int?
}
