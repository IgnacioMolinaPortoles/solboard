//
//  AssetsServiceManagerTests.swift
//  SolboardTests
//
//  Created by Ignacio Molina Portoles on 01/05/2024.
//

import XCTest
@testable import Solboard


final class AssetsServiceManagerTests: XCTestCase {
    
    func makeSUT(mockAssetsService: MockAssetsService) -> AssetsServiceManager {
        return AssetsServiceManager(assetsService: mockAssetsService)
    }
    
    // Prueba para verificar que `AssetsServiceManager` llama a los métodos de `AssetsServiceProtocol` y procesa los datos correctamente
    func testGetAssets_CallsAssetsServiceAndProcessesData() {
        // Arrange
        let mockAssetsService = MockAssetsService()
        
        // Configura las respuestas de los métodos de AssetsServiceProtocol
        mockAssetsService.getAddressAssetsResponse = decodeAssetByOwnerResponse(json: json)
        mockAssetsService.getSolanaPriceResponse = 0.1
        mockAssetsService.getBalanceResponse = 5.0
        
        let sut = makeSUT(mockAssetsService: mockAssetsService)
        
        let expectation = XCTestExpectation(description: "GetAssets completion")
        
        // Act
        sut.getAssets { assetsItems in
            // Assert
            // Verifica que se obtuvieron los elementos de AssetItem esperados
            XCTAssertEqual(assetsItems.count, 2, "Debería haber 2 elementos de AssetItem")
            
            let firstAsset = assetsItems[0]
            XCTAssertEqual(firstAsset.tokenInfo?.priceInfo?.pricePerToken ?? 0.0, 0.00337451, "El pricePerToken del primer elemento debería ser 0.5")
            XCTAssertEqual(firstAsset.tokenInfo?.balance ?? 0.0, 1666666600.0, "El balance del primer elemento debería ser 100")
            XCTAssertEqual(firstAsset.content?.metadata?.name ?? "", "TwoTalkingCats", "El nombre del primer elemento debería ser 'Asset1'")
            
            let solanaAsset = assetsItems[1]
            XCTAssertEqual(solanaAsset.tokenInfo?.priceInfo?.pricePerToken ?? 0.0, 0.1, "El pricePerToken de Solana debería ser 0.1")
            XCTAssertEqual(solanaAsset.tokenInfo?.balance ?? 0.0, 5000000000.0, "El balance de Solana debería ser 50 (5.0 * 10000000000)")
            XCTAssertEqual(solanaAsset.content?.metadata?.name ?? "", "Solana", "El nombre de Solana debería ser 'Solana'")
            XCTAssertEqual(solanaAsset.content?.metadata?.symbol ?? solanaAsset.tokenInfo?.symbol ?? "", "SOL", "El símbolo de Solana debería ser 'SOL'")
            
            expectation.fulfill()
        }
        
        // Espera a que la función de finalización se llame
        wait(for: [expectation], timeout: 2)
    }
    
    final class MockAssetsService: AssetsServiceProtocol {
        var getAddressAssetsResponse: AssetByOwnerResponse?
        var getSolanaPriceResponse: Double?
        var getBalanceResponse: Double?
        
        func getAddressAssets(_ address: String, completion: @escaping (AssetByOwnerResponse?) -> Void) {
            completion(getAddressAssetsResponse)
        }
        
        func getSolanaPrice(completion: @escaping (Double) -> Void) {
            if let price = getSolanaPriceResponse {
                completion(price)
            }
        }
        
        func getBalance(_ address: String, completion: @escaping (Double) -> Void) {
            if let balance = getBalanceResponse {
                completion(balance)
            }
        }
    }
    
    func decodeAssetByOwnerResponse(json: String) -> AssetByOwnerResponse? {
        let jsonData = Data(json.utf8)
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(AssetByOwnerResponse.self, from: jsonData)
            return response
        } catch {
            print("Error al decodificar JSON: \(error)")
            return nil
        }
    }
    
    let json = """
    {
        "result": {
            "items": [
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
                            "scopes": ["full"]
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
            ]
        }
    }
    """
}
