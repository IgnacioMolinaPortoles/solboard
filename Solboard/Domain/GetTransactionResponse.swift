//
//  GetTransactionResponse.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 05/05/2024.
//

import Foundation

// MARK: - GetSignatureResponse
struct GetSignatureResponse: Codable {
    let jsonrpc: String?
    let result: GetSignatureResult?
    let id: Int?
}

// MARK: - GetSignatureResult
struct GetSignatureResult: Codable {
    let blockTime: Int?
    let meta: GetSignatureMeta?
    let slot: Int?
    let transaction: GetSignatureTransaction?
}

// MARK: - GetSignatureMeta
struct GetSignatureMeta: Codable {
    let computeUnitsConsumed: Int?
    let err: GetSignatureErr?
    let fee: Int?
    let innerInstructions: [GetSignatureInnerInstruction]?
    let loadedAddresses: GetSignatureLoadedAddresses?
    let logMessages: [String]?
    let postBalances: [Int]?
    let postTokenBalances: [GetSignatureTokenBalance]?
    let preBalances: [Int]?
    let preTokenBalances: [GetSignatureTokenBalance]?
//    let rewards: [JSONAny]?
}

// MARK: - GetSignatureErr
struct GetSignatureErr: Codable {
    let instructionError: [GetSignatureInstructionErrorElement]?

    enum CodingKeys: String, CodingKey {
        case instructionError = "InstructionError"
    }
}

enum GetSignatureInstructionErrorElement: Codable {
    case getSignatureInstructionErrorClass(GetSignatureInstructionErrorClass?)
    case integer(Int?)
    
    func getStringValue() -> String {
        switch self {
        case .getSignatureInstructionErrorClass(let err):
            return "\(String(describing: err?.custom ?? 0))"
        case .integer(let int):
            return "\(String(describing: int ?? 0))"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        
        if let x = try? container.decode(GetSignatureInstructionErrorClass.self) {
            self = .getSignatureInstructionErrorClass(x)
            return
        }
        
        self = .integer(nil)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .getSignatureInstructionErrorClass(let x):
            try container.encode(x)
        case .integer(let x):
            try container.encode(x)
        }
    }
}

// MARK: - GetSignatureInstructionErrorClass
struct GetSignatureInstructionErrorClass: Codable {
    let custom: Int?

    enum CodingKeys: String, CodingKey {
        case custom = "Custom"
    }
}

// MARK: - GetSignatureInnerInstruction
struct GetSignatureInnerInstruction: Codable {
    let index: Int?
    let instructions: [GetSignatureInstruction]?
}

// MARK: - GetSignatureInstruction
struct GetSignatureInstruction: Codable {
    let accounts: [Int]?
    let data: String?
    let programIDIndex: Int?
    let stackHeight: Int?

    enum CodingKeys: String, CodingKey {
        case accounts, data
        case programIDIndex = "programIdIndex"
        case stackHeight
    }
}

// MARK: - GetSignatureLoadedAddresses
struct GetSignatureLoadedAddresses: Codable {
    let readonly, writable: [String]?
}

// MARK: - GetSignatureTokenBalance
struct GetSignatureTokenBalance: Codable {
    let accountIndex: Int?
    let mint: String?
    let owner: String?
    let programID: String?
    let uiTokenAmount: GetSignatureUITokenAmount?

    enum CodingKeys: String, CodingKey {
        case accountIndex, mint, owner
        case programID = "programId"
        case uiTokenAmount
    }
}

// MARK: - GetSignatureUITokenAmount
struct GetSignatureUITokenAmount: Codable {
    let amount: String?
    let decimals: Int?
    let uiAmount: Double?
    let uiAmountString: String?
}

// MARK: - GetSignatureTransaction
struct GetSignatureTransaction: Codable {
    let message: GetSignatureMessage?
    let signatures: [String]?
}

// MARK: - GetSignatureMessage
struct GetSignatureMessage: Codable {
    let accountKeys: [String]?
    let header: GetSignatureHeader?
    let instructions: [GetSignatureInstruction]?
    let recentBlockhash: String?
    let addressTableLookups: [GetSignatureAddressTableLookup]?
}

// MARK: - GetSignatureAddressTableLookup
struct GetSignatureAddressTableLookup: Codable {
    let accountKey: String?
    let readonlyIndexes, writableIndexes: [Int]?
}

// MARK: - GetSignatureHeader
struct GetSignatureHeader: Codable {
    let numReadonlySignedAccounts, numReadonlyUnsignedAccounts, numRequiredSignatures: Int?
}
