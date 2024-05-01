//
//  BarChartTests.swift
//  SolboardTests
//
//  Created by Ignacio Molina Portoles on 01/05/2024.
//

import XCTest
import SwiftUI
@testable import Solboard

class BarChartViewModelTests: XCTestCase {

    // Función helper para crear el SUT (Subject Under Test)
    func makeSUT(tokens: [TokenViewModel] = []) -> BarChartViewModel {
        return BarChartViewModel(tokens: tokens)
    }
    
    // Prueba para verificar que el ViewModel se inicia correctamente con la lista de tokens
    func testInit_StartsWithProvidedTokens() {
        // Arrange
        let expectedTokens = [
            TokenViewModel(tokenName: "Token1", tokenType: .fungible),
            TokenViewModel(tokenName: "Token2", tokenType: .nonFungible)
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
            TokenViewModel(tokenName: "Token1", tokenType: .fungible)
        ]
        
        // Act
        sut.updateTokens(tokens: newTokens)
        
        // Assert
        XCTAssertEqual(sut.tokens, newTokens, "El ViewModel debería actualizar la lista de tokens")
    }

    // Prueba para verificar que el ViewModel calcula correctamente los datos visuales del gráfico de barras
    func testChartData_ReflectsTokens() {
        // Arrange
        let tokens = [
            TokenViewModel(tokenName: "Token1", tokenType: .fungible),
            TokenViewModel(tokenName: "Token2", tokenType: .nonFungible)
        ]
        let sut = makeSUT(tokens: tokens)
        
        // Act
        let chartData = sut.chartData
        
        // Assert
        XCTAssertEqual(chartData.count, tokens.count, "La cantidad de datos para el gráfico de barras debería coincidir con la cantidad de tokens")
        
        // Verificamos que los colores coinciden con los tipos de tokens
        XCTAssertEqual(chartData[0].1, Color(hex: TokenType.fungible.hexColor), "El color del token fungible debería coincidir")
        XCTAssertEqual(chartData[1].1, Color(hex: TokenType.nonFungible.hexColor), "El color del token no fungible debería coincidir")
    }

    // Prueba para verificar que el ViewModel calcula correctamente los colores de los tipos de tokens
    func testTokenTypeColors_ReflectsTokenTypes() {
        // Arrange
        let sut = makeSUT()
        
        // Act
        let tokenTypeColors = sut.tokenTypeColors
        
        // Assert
        XCTAssertEqual(tokenTypeColors.count, [TokenType.fungible, TokenType.nonFungible].count, "Debería haber un color para cada tipo de token")
        
        // Verificamos los colores de cada tipo de token
        for (type, color) in tokenTypeColors {
            XCTAssertEqual(color, Color(hex: type.hexColor), "El color para \(type.displayableName) debería coincidir")
        }
    }
}

class BarChartTests: XCTestCase {

    // Helper para crear `BarChart` y su `ViewModel`
    func makeSUT(tokens: [TokenViewModel] = [],
                 onAssetTapDo: @escaping () -> Void = {}) -> BarChart {
        let viewModel = BarChartViewModel(tokens: tokens)
        return BarChart(viewModel: viewModel, onAssetTapDo: onAssetTapDo)
    }
    
    // Prueba para verificar que `BarChart` se inicializa correctamente con los parámetros proporcionados
    func testInit_StartsWithProvidedParameters() {
        // Arrange
        let tokens = [
            TokenViewModel(tokenName: "Token1", tokenType: .fungible),
            TokenViewModel(tokenName: "Token2", tokenType: .nonFungible)
        ]
        var didTapAsset = false
        
        // Act
        let sut = makeSUT(tokens: tokens, onAssetTapDo: {
            didTapAsset = true
        })
        
        // Assert
        XCTAssertNotNil(sut.viewModel, "El `BarChart` debería tener un `ViewModel`")
        XCTAssertFalse(didTapAsset, "El gráfico no debería haberse tocado inicialmente")
    }

    // Prueba para verificar que el gráfico muestra los datos de `BarChartViewModel`
    func testRender_ReflectsTokensFromViewModel() {
        // Arrange
        let tokens = [
            TokenViewModel(tokenName: "Token1", tokenType: .fungible),
            TokenViewModel(tokenName: "Token2", tokenType: .nonFungible)
        ]
        let sut = makeSUT(tokens: tokens)
        
        // Act
        let actualTokens = sut.viewModel.tokens
        
        // Assert
        XCTAssertEqual(actualTokens, tokens, "El `BarChart` debería reflejar los tokens del `ViewModel`")
    }

    // Prueba para verificar que el callback `onAssetTapDo` se ejecuta correctamente cuando se toca el gráfico
    func testOnAssetTapDo_CallsCallbackWhenChartTapped() {
        // Arrange
        var didTapAsset = false
        
        // Act
        let sut = makeSUT(onAssetTapDo: {
            didTapAsset = true
        })
        
        // Simula un toque en el gráfico
        sut.onAssetTapDo()
        
        // Assert
        XCTAssertTrue(didTapAsset, "El callback `onAssetTapDo` debería llamarse cuando se toca el gráfico")
    }
    
}
