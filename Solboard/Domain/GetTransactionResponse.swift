//
//  GetTransactionResponse.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 05/05/2024.
//

import Foundation

struct TransactionResponse: Decodable {
    let jsonrpc: String
    let id: Int
    let result: TransactionResult
}

struct TransactionResult: Decodable {
    let blockTime: Int?
    let meta: TransactionMeta?
    let slot: Int
    let transaction: TransactionDetails
    let version: Int?
}

struct TransactionMeta: Decodable {
    let err: TransactionError?
    let fee: Int?
    let innerInstructions: [InnerInstruction]
    let postBalances: [UInt64]
    let postTokenBalances: [TokenBalance]
    let preBalances: [UInt64]
    let preTokenBalances: [TokenBalance]
    let rewards: [Reward]
    let status: TransactionStatus
}

struct TransactionError: Decodable {
    let instructionError: InstructionErrorType?
}


struct TransactionStatus: Decodable {
    let Ok: Bool?
    let Err: TransactionErrorDetail?
}

struct TransactionErrorDetail: Decodable {
    let InstructionError: [InstructionErrorType]?
}

enum InstructionErrorType: Decodable {
    case simple(Int)
    case detailed(Int, CustomError)
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let code = try container.decode(Int.self)
        if container.isAtEnd {
            self = .simple(code)
        } else {
            let customError = try container.decode(CustomError.self)
            self = .detailed(code, customError)
        }
    }
}

struct CustomError: Decodable {
    let custom: Int
    
    enum CodingKeys: String, CodingKey {
        case custom = "Custom"
    }
}

struct InnerInstruction: Decodable {
    let index: Int
    let instructions: [Instruction]
}

struct Instruction: Decodable {
    let accounts: [Int]
    let data: String
    let programIdIndex: Int
    let stackHeight: Int?
}

struct TokenBalance: Decodable {
    let accountIndex: Int
    let mint: String
    let owner: String
    let programId: String
    let uiTokenAmount: UiTokenAmount
}

struct UiTokenAmount: Decodable {
    let amount: String
    let decimals: Int
    let uiAmount: Double
    let uiAmountString: String
}

struct Reward: Decodable {
    let pubkey: String
    let lamports: Int
    let postBalance: Int
    let rewardType: String
}

struct TransactionDetails: Decodable {
    let message: TransactionMessage
    let signatures: [String]
}

struct TransactionMessage: Decodable {
    let accountKeys: [String]
    let header: TransactionHeader
    let instructions: [Instruction]
    let recentBlockhash: String
}

struct TransactionHeader: Decodable {
    let numReadonlySignedAccounts: Int
    let numReadonlyUnsignedAccounts: Int
    let numRequiredSignatures: Int
}
