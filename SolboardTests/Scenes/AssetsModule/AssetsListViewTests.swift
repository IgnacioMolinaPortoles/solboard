//
//  AssetsListViewTests.swift
//  SolboardTests
//
//  Created by Ignacio Molina Portoles on 01/05/2024.
//

import XCTest
@testable import Solboard

class AssetsListViewModelTests: XCTestCase {

    // Función helper para crear el SUT (Subject Under Test)
    func makeSUT(tokens: [AssetItemViewModel] = []) -> AssetsListViewModel {
        return AssetsListViewModel(tokens: tokens)
    }

    // Prueba para verificar que el ViewModel se inicia correctamente con la lista de tokens
    func testInit_StartsWithProvidedTokens() {
        // Arrange
        let expectedTokens = [
            AssetItemViewModel(address: "1", name: "Token1", symbol: "TK1", tokenType: .fungible, image: nil),
            AssetItemViewModel(address: "2", name: "NFT1", symbol: "NFT1", tokenType: .nonFungible, image: nil)
        ]
        
        // Act
        let sut = makeSUT(tokens: expectedTokens)
        
        // Assert
        XCTAssertEqual(sut.tokens, expectedTokens, "El ViewModel debería iniciarse con los tokens proporcionados")
    }

    // Prueba para verificar que el ViewModel actualiza correctamente la lista de tokens
    func testUpdateTokens_UpdatesTokens() {
        // Arrange
        let sut = makeSUT(tokens: [])
        let newTokens = [
            AssetItemViewModel(address: "1", name: "Token1", symbol: "TK1", tokenType: .fungible, image: nil)
        ]
        
        // Act
        sut.updateTokens(tokens: newTokens)
        
        // Assert
        XCTAssertEqual(sut.tokens, newTokens, "El ViewModel debería actualizar la lista de tokens")
    }

    // Prueba para verificar que el ViewModel filtra los tokens correctamente por búsqueda y segmentación
    func testFilteredTokens_FiltersTokensBySearchAndSegment() {
        // Arrange
        let tokens = [
            AssetItemViewModel(address: "1", name: "Token1", symbol: "TK1", tokenType: .fungible, image: nil),
            AssetItemViewModel(address: "2", name: "NFT1", symbol: "NFT1", tokenType: .nonFungible, image: nil)
        ]
        let sut = makeSUT(tokens: tokens)
        sut.assetSelected = 0 // Tokens
        
        // Act
        sut.searchText = "Token"
        
        // Assert
        let filteredTokens = sut.filteredTokens
        XCTAssertEqual(filteredTokens.count, 1, "Debería haber un token filtrado por búsqueda")
        XCTAssertEqual(filteredTokens[0], tokens[0], "El token filtrado debería ser el fungible")
        
        // Cambiar a segmentación de NFTs
        sut.assetSelected = 1 // NFTs
        sut.searchText = "NFT"
        
        // Act
        let filteredNFTs = sut.filteredTokens
        
        // Assert
        XCTAssertEqual(filteredNFTs.count, 1, "Debería haber un NFT filtrado por búsqueda")
        XCTAssertEqual(filteredNFTs[0], tokens[1], "El NFT filtrado debería ser el no fungible")
    }

    // Prueba para verificar que el ViewModel maneja la selección de un activo correctamente
    func testSelectAsset_CallsAssetDetailTap() {
        // Arrange
        var token = AssetItemViewModel(address: "1", name: "Token1", symbol: "TK1", tokenType: .fungible, image: nil)
        var didTapAssetDetail = false
        token.onAssetDetailTap = {
            didTapAssetDetail = true
        }
        
        let sut = makeSUT(tokens: [token])
        
        // Act
        sut.selectAsset(token)
        
        // Assert
        XCTAssertTrue(didTapAssetDetail, "Debería haber llamado a `onAssetDetailTap` al seleccionar el activo")
    }
}
