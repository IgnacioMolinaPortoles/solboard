//
//  HomeTests.swift
//  SolboardTests
//
//  Created by Ignacio Molina Portoles on 10/04/2024.
//

import XCTest
@testable import Solboard

class HomeViewControllerTests: XCTestCase {
    
    // Función helper para crear el SUT (Subject Under Test)
    func makeSUT(
        assetServiceManager: AssetsServiceManagerProtocol = MockAssetsServiceManager(),
        transactionsService: TransactionsServiceProtocol = MockTransactionsServiceProtocol(),
        coordinator: (TransactionRouting & AssetRouting) = MockCoordinator()
    ) -> HomeViewController {
        let viewModel = HomeViewModel(assetServiceManager: assetServiceManager, transactionsService: transactionsService)
        let sut = HomeViewController(viewModel: viewModel, coordinator: coordinator)
        return sut
    }
    
    // Prueba para verificar que la etiqueta de balance se actualiza correctamente
    func testViewController_UpdatesBalanceLabel() {
        // Arrange
        let mockAssetServiceManager = MockAssetsServiceManager()
        let sut = makeSUT(assetServiceManager: mockAssetServiceManager)
        let expectation = XCTestExpectation(description: "La etiqueta de balance debería actualizarse")
        
        // Act
        sut.loadViewIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(sut.balanceLabel.text, "Balance: $0.00", "La etiqueta de balance no se actualizó correctamente")
        }
    }
    
    // Prueba para verificar que la etiqueta de transacciones se actualiza correctamente
    func testViewController_UpdatesTransactionsLabel() {
        // Arrange
        let mockTransactionsService = MockTransactionsServiceProtocol()
        let sut = makeSUT(transactionsService: mockTransactionsService)
        let expectation = XCTestExpectation(description: "La etiqueta de transacciones debería actualizarse")
        
        // Act
        sut.loadViewIfNeeded()
        mockTransactionsService.getSignatures(address) { _ in
            // Assert
            DispatchQueue.main.async {
                XCTAssertNotNil(sut.transactionsView, "La vista de transacciones debería haber sido añadida")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    // Ejemplo de Mock del coordinador
    final class MockCoordinator: TransactionRouting & AssetRouting {
        private(set) var txsRouted: [String] = []
        private(set) var assetsToBuildAssetsView: [AssetItem] = []

        private(set) var routeToTransactionDetailCalled: Bool = false
        private(set) var routeToAssetViewCalled: Bool = false

        func routeToTransactionDetail(tx: String) {
            routeToTransactionDetailCalled = true
            txsRouted.append(tx)
        }
        
        func routeToAssetView(assets: [AssetItem]) {
            routeToAssetViewCalled = true
            self.assetsToBuildAssetsView = assets
        }
    }
    
    final class MockAssetsServiceManager: AssetsServiceManagerProtocol {
        var didFetchAssets = false
        
        func getAssets(completion: @escaping ([AssetItem]) -> Void) {
            didFetchAssets = true
            completion([AssetItem]())
        }
    }
    
    final class MockTransactionsServiceProtocol: TransactionsServiceProtocol {
        var didFetchTransactions = false
        
        func getSignatures(_ address: String, completion: @escaping ([TransactionViewModel]) -> Void) {
            didFetchTransactions = true
            completion([TransactionViewModel]())
        }
    }
}
