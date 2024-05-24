//
//  HomeCoordinatorTests.swift
//  SolboardTests
//
//  Created by Ignacio Molina Portoles on 04/05/2024.
//

import Foundation
import XCTest
import SwiftUI
@testable import Solboard

class HomeCoordinatorTests: XCTestCase {
    
    func testRouteToTransactionDetail_NavigatesToCorrectURL() {
        // Arrange
        let mockUIApplication = MockUIApplication()
        let mockNavigationController = MockNavigationController()
        let coordinator = HomeCoordinator(navigationController: mockNavigationController, 
                                          uiApplication: mockUIApplication,
                                          dataManager: UserDataManagerMock(hasUser: false))
        let transactionHash = "exampleTxHash"
        
        // Act
        coordinator.routeToTransactionDetail(tx: transactionHash)
        
        // Assert
        XCTAssertTrue(mockNavigationController.pushedViewControllers.count == 1, "Detail viewcontroller should be pushed into navigation")
    }
    
    func testOnAssetDetailTap_PresentsDetailsViewCorrectly() {
        // Arrange
        let mockNavigationController = MockNavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: mockNavigationController, 
                                              uiApplication: UIApplication.shared,
                                              dataManager: UserDataManagerMock(hasUser: false))
        
        let assetItem = AssetItem(id: "test-id", pricePerToken: 0.5, balance: 100, name: "TestAsset", symbol: "TEST", tokenType: .fungible, image: "image")
        
        // Act
        homeCoordinator.onAssetDetailTap(item: assetItem)
        
        // Assert
        // Verifica que se presentó una vista controladora
        XCTAssertEqual(mockNavigationController.pushedViewControllers.count, 1, "Debería presentarse una vista controladora")
        
        let presentedViewController = mockNavigationController.pushedViewControllers.first
        XCTAssertTrue(presentedViewController is UIHostingController<DetailsView>, "Debería presentarse un UIHostingController con DetailsView")
        
        if let hostingController = presentedViewController as? UIHostingController<DetailsView> {
            let detailViewModel = hostingController.rootView.detailItem
            XCTAssertEqual(detailViewModel.id, assetItem.id, "El DetailItemViewModel debería tener el ID correcto")
            XCTAssertEqual(detailViewModel.name, assetItem.content?.metadata?.name, "El DetailItemViewModel debería tener el nombre correcto")
        }
    }
    
    func testRouteToAssetView_NavigatesToCorrectView() {
        // Arrange
        let mockUIApplication = MockUIApplication()
        let mockNavigationController = MockNavigationController()
        let coordinator = HomeCoordinator(navigationController: mockNavigationController,
                                          uiApplication: mockUIApplication,
                                          dataManager: UserDataManagerMock(hasUser: false))
        let assetItem = AssetItem(id: "test-id", pricePerToken: 0.5, balance: 100, name: "TestAsset", symbol: "TEST", tokenType: .fungible, image: "image")
        
        // Act
        coordinator.routeToAssetView(assets: [assetItem])
        
        // Assert
        let presentedVC = mockNavigationController.pushedViewControllers.last
        XCTAssertTrue(presentedVC is UIHostingController<AssetsListView>, "Debería presentarse la vista AssetsListView")
        
        let hostingVC = presentedVC as! UIHostingController<AssetsListView>
        let viewModel = hostingVC.rootView.viewModel
        XCTAssertEqual(viewModel.tokens.count, 1, "Debería haber un AssetItemViewModel")
        XCTAssertEqual(viewModel.tokens[0].address, "test-id", "El address del AssetItemViewModel debería coincidir con el ID del AssetItem")
    }
    
    func testRouteToWeb_OpensCorrectURL() {
        // Arrange
        let mockUIApplication = MockUIApplication()
        let mockNavigationController = MockNavigationController()
        let coordinator = HomeCoordinator(navigationController: mockNavigationController,
                                          uiApplication: mockUIApplication,
                                          dataManager: UserDataManagerMock(hasUser: false))
        let assetItem = AssetItem(id: "test-id", pricePerToken: 0.5, balance: 100, name: "TestAsset", symbol: "TEST", tokenType: .fungible, image: "image")
        
        // Act
        coordinator.routeToWeb(item: assetItem)
        
        // Assert
        let expectedURL = URL(string: "https://solscan.io/token/test-id")!
        XCTAssertTrue(mockUIApplication.openedURLs.contains(expectedURL), "Debería abrirse la URL correcta")
    }
    
    // Mock de UIApplicationURLRouterProtocol
    class MockUIApplication: UIApplicationURLRouterProtocol {
        var canOpenURLReturnValue = true
        var openedURLs: [URL] = []
        
        func _canOpenURL(_ url: URL) -> Bool {
            return canOpenURLReturnValue
        }
        
        func _open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:], completionHandler: ((Bool) -> Void)?) {
            openedURLs.append(url)
            completionHandler?(true)
        }
    }
    
    // Mock de UINavigationController para verificar la navegación
    class MockNavigationController: UINavigationController {
        var pushedViewControllers: [UIViewController] = []
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: animated)
            pushedViewControllers.append(viewController)
        }
    }
}
