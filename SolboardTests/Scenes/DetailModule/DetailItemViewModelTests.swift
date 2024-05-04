//
//  DetailItemViewModelTests.swift
//  SolboardTests
//
//  Created by Ignacio Molina Portoles on 01/05/2024.
//

import XCTest
@testable import Solboard

import XCTest
@testable import Solboard

class DetailItemViewModelTests: XCTestCase {
    
    private func convertJsonToAssetItem(json: String) -> AssetItem? {
        let jsonData = Data(json.utf8)
        let decoder = JSONDecoder()
        
        do {
            let assetItem = try decoder.decode(AssetItem.self, from: jsonData)
            return assetItem
        } catch {
            print("Error al decodificar JSON: \(error)")
            return nil
        }
    }
    
    func testFormattedProperties_AreFormattedCorrectly() {
        // Arrange
        guard let assetItem = convertJsonToAssetItem(json: tokenJson) else {
            XCTFail("El JSON no se decodificó correctamente a AssetItem")
            return
        }
        let sut = DetailItemViewModel(from: assetItem, goToWeb: {})
        
        // Assert
        XCTAssertEqual(sut.formattedBalance, "1666.67", "El balance formateado debería ser '1.67'")
        XCTAssertEqual(sut.formattedPricePerToken, "$0,00337451", "El precio por token formateado debería ser '$0.00'")
        XCTAssertEqual(sut.formattedTotalValue, "$5.62", "El valor total formateado debería ser '$5.62'")
        XCTAssertEqual(sut.formattedRoyaltyFee, "0.00%", "La tarifa de regalías formateada debería ser '0.00%'")
        XCTAssertEqual(sut.formattedAddress, "AB1e1r...RmQksd", "La dirección formateada debería ser 'AB1e1r...RmQksd' o una versión corta")
    }
}



let tokenJson = """
{
        "interface": "FungibleToken",
        "id": "AB1e1rTGF8xSoYzXEwNWohuMHLCMrBoaSxT6AARmQksd",
        "content": {
          "$schema": "https://schema.metaplex.com/nft1.0.json",
          "json_uri": "https://gateway.irys.xyz/OcGcH3rSV1UqNiJsyx-RvmqDdLRnRut-N7Jz2Vim4gU",
          "files": [
            {
              "uri": "https://i.imgur.com/jmoirLq.jpeg",
              "cdn_uri": "https://cdn.helius-rpc.com/cdn-cgi/image//https://i.imgur.com/jmoirLq.jpeg",
              "mime": "image/jpeg"
            }
          ],
          "metadata": {
            "description": "Just Two Cats Talking About Life",
            "name": "TwoTalkingCats",
            "symbol": "TWOCAT",
            "token_standard": "Fungible"
          },
          "links": {
            "image": "https://i.imgur.com/jmoirLq.jpeg"
          }
        },
        "authorities": [
          {
            "address": "DkMe3tyhndt8d8FjYseszkGiyPaqTgLPvuwSzo5DQbY3",
            "scopes": [
              "full"
            ]
          }
        ],
        "compression": {
          "eligible": false,
          "compressed": false,
          "data_hash": "",
          "creator_hash": "",
          "asset_hash": "",
          "tree": "",
          "seq": 0,
          "leaf_id": 0
        },
        "grouping": [],
        "royalty": {
          "royalty_model": "creators",
          "target": null,
          "percent": 0,
          "basis_points": 0,
          "primary_sale_happened": false,
          "locked": false
        },
        "creators": [],
        "ownership": {
          "frozen": false,
          "delegated": false,
          "delegate": null,
          "ownership_model": "token",
          "owner": "AUXVBHMKvW6arSPPNbjSuz8y3f6HA2p8YCcKLr8HBGdh"
        },
        "supply": null,
        "mutable": true,
        "burnt": false,
        "token_info": {
          "symbol": "TWOCAT",
          "balance": 1666666600,
          "supply": 999982329407904,
          "decimals": 6,
          "token_program": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
          "associated_token_address": "8Y5di26DbFH3afDYqYYC7Lvp5ZrP4ihZ7ciXSoPs6KCZ",
          "price_info": {
            "price_per_token": 0.00337451,
            "total_price": 5.624183073431719,
            "currency": "USDC"
          }
        }
      }
"""
