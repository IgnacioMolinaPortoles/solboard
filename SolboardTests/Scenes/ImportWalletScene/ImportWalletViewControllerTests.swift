//
//  ImportWalletViewControllerTests.swift
//  SolboardTests
//
//  Created by Ignacio Molina Portoles on 08/04/2024.
//

import XCTest
import Combine
@testable import Solboard

final class ImportWalletViewControllerTests: XCTestCase {

    var sut: ImportWalletViewController!
    var coordinator: ImportWalletCoordinatorMock!
    var alertManagerMock: AlertManagerMock!
    var service: ValidatorServiceDummy!
    
    override func setUpWithError() throws {
        self.coordinator = ImportWalletCoordinatorMock()
        self.alertManagerMock = AlertManagerMock()
        self.service = ValidatorServiceDummy()
        
        let vm = ImportWalletViewModel(validatorService: self.service)
        
        self.sut = ImportWalletViewController(viewModel: vm, coordinator: self.coordinator, alertManager: self.alertManagerMock)
        self.sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        self.sut = nil
        self.coordinator = nil
    }

    func testValidAddress() throws {
        //Arrange
        sut.addressTextView.text = "aaa"
        self.service.servicetExpectation = expectation(description: "service called")
        
        //Act
        sut.onContinueButtonTapDo(self)
        waitForExpectations(timeout: 2)
        //Assert
        
        XCTAssertTrue(self.coordinator.buildHomeCalled)
    }
    
    func testInvalidAddress() throws {
        //Arrange
        sut.addressTextView.text = "bbb"
        self.service.servicetExpectation = expectation(description: "service called")

        //Act
        sut.onContinueButtonTapDo(self)
        waitForExpectations(timeout: 0.1)

        //Assert
        XCTAssertTrue(self.alertManagerMock.alertShown)
    }
}

extension XCTestCase {
    final class ImportWalletCoordinatorMock: Coordinator, HomeBuilding {
        var childCoordinators: [Solboard.Coordinator] = []
        var navigationController: UINavigationController = UINavigationController()
        
        private(set) var buildHomeCalled = false
        
        func start() {}

        func buildHome() {
            buildHomeCalled = true
        }
    }
    
    final class AlertManagerMock: AlertManager {
        private(set) var alertShown = false

        override func showAlert(_ title: String, _ message: String?, actions: [UIAlertAction]?, viewController: UIViewController?) {
            alertShown = true
        }
    }
    
    final class ValidatorServiceDummy: ValidatorServiceProtocol {
        var servicetExpectation: XCTestExpectation?

        func isValidAddress(_ address: String, completion: @escaping (Bool) -> Void) {
            if address == "aaa" {
                completion(true)
            } else {
                completion(false)
            }
            servicetExpectation?.fulfill()
        }
    }
}
