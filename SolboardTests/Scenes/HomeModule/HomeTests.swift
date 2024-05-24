//
//  HomeTests.swift
//  SolboardTests
//
//  Created by Ignacio Molina Portoles on 10/04/2024.
//

import XCTest
@testable import Solboard

class HomeViewControllerTests: XCTestCase {
    
    func testHomeViewController_UserImage_ShouldPresentSettingsVC() {
        let coordinator = MockCoordinator()
        let sut = makeSUT(coordinator: coordinator)
        
        sut.loadViewIfNeeded()
        sut.routeToSettings()
        
        XCTAssertTrue(coordinator.routeToSettingsCalled)
    }
    
    func testHomeViewController_UserImage_ShouldHaveGestureRecognizer() {
        let coordinator = MockCoordinator()
        let sut = makeSUT(coordinator: coordinator)
        
        sut.loadViewIfNeeded()
        
        let gestureRecognizers = sut.userImage.gestureRecognizers
        XCTAssertNotNil(gestureRecognizers)
        XCTAssertNotEqual(gestureRecognizers?.count, 0)
        XCTAssertEqual(gestureRecognizers?.count, 1)
        XCTAssertNotEqual(gestureRecognizers?.count, 2)
        XCTAssertTrue(gestureRecognizers?.first is UITapGestureRecognizer)
    }
    
    func testHomeViewController_ShouldHaveUserImage() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.userImage)
        XCTAssertEqual(sut.userImage.accessibilityLabel, "person.circle")
    }
 
    func testViewController_UpdatesBalanceLabel() {
        // Arrange
        let mockAssetServiceManager = MockAssetsServiceManager()
        let sut = makeSUT(assetServiceManager: mockAssetServiceManager)
        
        // Act
        sut.loadViewIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(sut.balanceLabel.text, "Balance: $0.00", "La etiqueta de balance no se actualizó correctamente")
        }
    }
    
    func testViewController_UpdatesTransactionsLabel() {
        // Arrange
        let mockTransactionsService = MockTransactionsServiceProtocol()
        let sut = makeSUT(transactionsService: mockTransactionsService)
        let expectation = XCTestExpectation(description: "La etiqueta de transacciones debería actualizarse")
        
        // Act
        sut.loadViewIfNeeded()
        mockTransactionsService.getSignatures("address") { _ in
            // Assert
            DispatchQueue.main.async {
                XCTAssertNotNil(sut.transactionsView, "La vista de transacciones debería haber sido añadida")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}

extension HomeViewControllerTests {
    func makeSUT(
        assetServiceManager: AssetsServiceManagerProtocol = MockAssetsServiceManager(),
        transactionsService: TransactionsServiceProtocol = MockTransactionsServiceProtocol(),
        coordinator: (TransactionRouting & AssetRouting & SettingsRouting) = MockCoordinator()
    ) -> HomeViewController {
        let viewModel = HomeViewModel(assetServiceManager: assetServiceManager,
                                      transactionsService: transactionsService,
                                      dataManager: UserDataManagerMock(hasUser: false))
        let sut = HomeViewController(viewModel: viewModel, coordinator: coordinator)
        return sut
    }
    
    final class MockCoordinator: TransactionRouting & AssetRouting & SettingsRouting {
        private(set) var txsRouted: [String] = []
        private(set) var assetsToBuildAssetsView: [AssetItem] = []

        private(set) var routeToTransactionDetailCalled: Bool = false
        private(set) var routeToAssetViewCalled: Bool = false
        private(set) var routeToAllTransactionsCalled: Bool = false
        private(set) var routeToSettingsCalled: Bool = false

        func routeToSettings() {
            routeToSettingsCalled = true
        }
        
        func routeToTransactionDetail(tx: String) {
            routeToTransactionDetailCalled = true
            txsRouted.append(tx)
        }
        
        func routeToAssetView(assets: [AssetItem]) {
            routeToAssetViewCalled = true
            self.assetsToBuildAssetsView = assets
        }
        
        func routeToAllTransactions(txs: [TransactionViewModel]) {
            routeToAllTransactionsCalled = true
        }
    }
    
    final class MockAssetsServiceManager: AssetsServiceManagerProtocol {
        var didFetchAssets = false
        
        func getAssets(_ address: String, completion: @escaping ([AssetItem]) -> Void) {
            didFetchAssets = true
            completion([AssetItem]())
        }
    }
    
    final class MockTransactionsServiceProtocol: TransactionsServiceProtocol {
        var didFetchTransactions = false
        var didGetTransaction = false
        
        func getSignatures(_ address: String, completion: @escaping ([TransactionViewModel]) -> Void) {
            didFetchTransactions = true
            completion([TransactionViewModel]())
        }
        
        func getTransaction(_ tx: String, completion: @escaping (Solboard.GetSignatureResponse?) -> Void) {
            didGetTransaction = true
            completion(nil)
        }
    }
    
}
