//
//  GetSignaturesForAddressResponse.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 14/04/2024.
//

import Foundation

// MARK: - GetSignaturesWelcome
struct GetSignaturesResponse: Codable {
    let jsonrpc: String?
    let result: [GetSignaturesResult]?
    let id: Int?
}

// MARK: - GetSignaturesResult
struct GetSignaturesResult: Codable {
    let blockTime: Int?
    let confirmationStatus: String?
    let err: GetSignaturesErr?
    let memo: String?
    let signature: String?
    let slot: Int?
}

// MARK: - GetSignaturesErr
struct GetSignaturesErr: Codable {
    let instructionError: [GetSignaturesInstructionErrorElement]?

    enum CodingKeys: String, CodingKey {
        case instructionError = "InstructionError"
    }
}

enum GetSignaturesInstructionErrorElement: Codable {
    case getSignaturesInstructionErrorClass(GetSignaturesInstructionErrorClass)
    case integer(Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(GetSignaturesInstructionErrorClass.self) {
            self = .getSignaturesInstructionErrorClass(x)
            return
        }
        throw DecodingError.typeMismatch(GetSignaturesInstructionErrorElement.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for GetSignaturesInstructionErrorElement"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .getSignaturesInstructionErrorClass(let x):
            try container.encode(x)
        case .integer(let x):
            try container.encode(x)
        }
    }
}

// MARK: - GetSignaturesInstructionErrorClass
struct GetSignaturesInstructionErrorClass: Codable {
    let custom: Int?

    enum CodingKeys: String, CodingKey {
        case custom = "Custom"
    }
}
