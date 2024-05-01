//
//  AssetsByOwnerResponse.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 11/04/2024.
//

import Foundation

// MARK: - AssetResponse
struct AssetByOwnerResponse: Codable {
    let jsonrpc: String?
    var result: AssetResult?
    let id: Int?
}

// MARK: - AssetResult
struct AssetResult: Codable {
    let total, limit, page: Int?
    var items: [AssetItem]?
}

// MARK: - AssetItem
struct AssetItem: Codable {
    let interface: String?
    let id: String?
    let content: AssetContent?
    let authorities: [AssetAuthority]?
    let compression: AssetCompression?
    let grouping: [AssetGrouping]?
    let royalty: AssetRoyalty?
    let creators: [AssetCreator]?
    let ownership: AssetOwnership?
    let supply: AssetSupply?
    let mutable, burnt: Bool?
    let tokenInfo: AssetTokenInfo?
    let mintExtensions: AssetMintExtensions?
    
    init(pricePerToken: Double,
         balance: Double,
         name: String,
         symbol: String,
         tokenType: TokenType,
         image: String) {
        // Inicializar el interface e id como valores predeterminados nulos
        self.interface = nil
        self.id = nil
        
        // Inicializar AssetContent con image, name y symbol
        let assetMetadata = AssetMetadata(attributes: nil, description: nil, name: name, symbol: symbol, tokenStandard: tokenType.rawValue)
        self.content = AssetContent(schema: nil, jsonURI: nil, files: [AssetFile(uri: image, cdnURI: nil, mime: nil)], metadata: assetMetadata, links: nil)
        
        // Inicializar AssetTokenInfo con pricePerToken, balance y symbol
        let assetPriceInfo = AssetPriceInfo(pricePerToken: pricePerToken, totalPrice: nil, currency: nil)
        self.tokenInfo = AssetTokenInfo(
            balance: balance,
            supply: nil,
            decimals: 10,
            tokenProgram: nil,
            associatedTokenAddress: nil,
            mintAuthority: nil,
            freezeAuthority: nil,
            symbol: symbol,
            priceInfo: assetPriceInfo
        )
        
        // Inicializar todas las otras propiedades opcionales como nulas
        self.authorities = nil
        self.compression = nil
        self.grouping = nil
        self.royalty = nil
        self.creators = nil
        self.ownership = nil
        self.supply = nil
        self.mutable = nil
        self.burnt = nil
        self.mintExtensions = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case interface, id, content, authorities, compression, grouping, royalty, creators, ownership, supply, mutable, burnt
        case tokenInfo = "token_info"
        case mintExtensions = "mint_extensions"
    }
}

// MARK: - AssetAuthority
struct AssetAuthority: Codable {
    let address: String?
    let scopes: [String]?
}

// MARK: - AssetCompression
struct AssetCompression: Codable {
    let eligible, compressed: Bool?
    let dataHash, creatorHash, assetHash, tree: String?
    let seq, leafID: Int?
    
    enum CodingKeys: String, CodingKey {
        case eligible, compressed
        case dataHash = "data_hash"
        case creatorHash = "creator_hash"
        case assetHash = "asset_hash"
        case tree, seq
        case leafID = "leaf_id"
    }
}

// MARK: - AssetContent
struct AssetContent: Codable {
    let schema: String?
    let jsonURI: String?
    let files: [AssetFile]?
    let metadata: AssetMetadata?
    let links: AssetLinks?
    
    enum CodingKeys: String, CodingKey {
        case schema = "$schema"
        case jsonURI = "json_uri"
        case files, metadata, links
    }
}

// MARK: - AssetFile
struct AssetFile: Codable {
    let uri: String?
    let cdnURI: String?
    let mime: String?
    
    enum CodingKeys: String, CodingKey {
        case uri
        case cdnURI = "cdn_uri"
        case mime
    }
}

// MARK: - AssetLinks
struct AssetLinks: Codable {
    let image: String?
    let externalURL: String?
    let animationURL: String?
    
    enum CodingKeys: String, CodingKey {
        case image
        case externalURL = "external_url"
        case animationURL = "animation_url"
    }
}

// MARK: - AssetMetadata
struct AssetMetadata: Codable {
    let attributes: [AssetAttribute]?
    let description, name, symbol: String?
    let tokenStandard: String?
    
    enum CodingKeys: String, CodingKey {
        case attributes, description, name, symbol
        case tokenStandard = "token_standard"
    }
}

// MARK: - AssetAttribute
struct AssetAttribute: Codable {
    let value: AssetValue?
    let traitType: String?
    
    enum CodingKeys: String, CodingKey {
        case value
        case traitType = "trait_type"
    }
}

enum AssetValue: Codable {
    case integer(Int)
    case string(String)
    
    var stringValue: String {
        switch self {
        case .integer(let int):
            return "\(int)"
        case .string(let string):
            return string
        }
    }
    
    init(_ int: Int) {
        self = .integer(int)
    }
    
    init(_ string: String) {
        self = .string(string)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(AssetValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for AssetValue"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - AssetCreator
struct AssetCreator: Codable {
    let address: String?
    let share: Int?
    let verified: Bool?
}

// MARK: - AssetGrouping
struct AssetGrouping: Codable {
    let groupKey: String?
    let groupValue: String?
    
    enum CodingKeys: String, CodingKey {
        case groupKey = "group_key"
        case groupValue = "group_value"
    }
}

// MARK: - AssetMintExtensions
struct AssetMintExtensions: Codable {
    let transferFeeConfig: AssetTransferFeeConfig?
    
    enum CodingKeys: String, CodingKey {
        case transferFeeConfig = "transfer_fee_config"
    }
}

// MARK: - AssetTransferFeeConfig
struct AssetTransferFeeConfig: Codable {
    let withheldAmount: Double?
    let newerTransferFee, olderTransferFee: AssetErTransferFee?
    let withdrawWithheldAuthority, transferFeeConfigAuthority: String?
    
    enum CodingKeys: String, CodingKey {
        case withheldAmount = "withheld_amount"
        case newerTransferFee = "newer_transfer_fee"
        case olderTransferFee = "older_transfer_fee"
        case withdrawWithheldAuthority = "withdraw_withheld_authority"
        case transferFeeConfigAuthority = "transfer_fee_config_authority"
    }
}

// MARK: - AssetErTransferFee
struct AssetErTransferFee: Codable {
    let epoch: Int?
    let maximumFee: Double?
    let transferFeeBasisPoints: Int?
    
    enum CodingKeys: String, CodingKey {
        case epoch
        case maximumFee = "maximum_fee"
        case transferFeeBasisPoints = "transfer_fee_basis_points"
    }
}

// MARK: - AssetOwnership
struct AssetOwnership: Codable {
    let frozen, delegated: Bool?
    let delegate: String?
    let ownershipModel: String?
    let owner: String?
    
    enum CodingKeys: String, CodingKey {
        case frozen, delegated, delegate
        case ownershipModel = "ownership_model"
        case owner
    }
}

// MARK: - AssetRoyalty
struct AssetRoyalty: Codable {
    let royaltyModel: String?
    let target: String?
    let percent: Double?
    let basisPoints: Int?
    let primarySaleHappened, locked: Bool?
    
    enum CodingKeys: String, CodingKey {
        case royaltyModel = "royalty_model"
        case target, percent
        case basisPoints = "basis_points"
        case primarySaleHappened = "primary_sale_happened"
        case locked
    }
}
// MARK: - AssetSupply
struct AssetSupply: Codable {
    let printMaxSupply, printCurrentSupply: Int?
    let editionNonce: Int?
    let editionNumber: Int?
    let masterEditionMint: String?
    
    enum CodingKeys: String, CodingKey {
        case printMaxSupply = "print_max_supply"
        case printCurrentSupply = "print_current_supply"
        case editionNonce = "edition_nonce"
        case editionNumber = "edition_number"
        case masterEditionMint = "master_edition_mint"
    }
}

// MARK: - AssetTokenInfo
struct AssetTokenInfo: Codable {
    let balance: Double?
    let supply: Double?
    let decimals: Int?
    let tokenProgram: String?
    let associatedTokenAddress, mintAuthority, freezeAuthority, symbol: String?
    let priceInfo: AssetPriceInfo?
    
    enum CodingKeys: String, CodingKey {
        case balance, supply, decimals
        case tokenProgram = "token_program"
        case associatedTokenAddress = "associated_token_address"
        case mintAuthority = "mint_authority"
        case freezeAuthority = "freeze_authority"
        case symbol
        case priceInfo = "price_info"
    }
}

// MARK: - AssetPriceInfo
struct AssetPriceInfo: Codable {
    let pricePerToken, totalPrice: Double?
    let currency: String?
    
    enum CodingKeys: String, CodingKey {
        case pricePerToken = "price_per_token"
        case totalPrice = "total_price"
        case currency
    }
}
