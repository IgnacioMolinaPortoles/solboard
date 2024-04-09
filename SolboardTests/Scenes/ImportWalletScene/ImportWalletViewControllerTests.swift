//
//  ImportWalletViewControllerTests.swift
//  SolboardTests
//
//  Created by Ignacio Molina Portoles on 08/04/2024.
//

import XCTest
@testable import Solboard

final class ImportWalletViewControllerTests: XCTestCase {

    var sut: ImportWalletViewController!
    var coordinator: ImportWalletCoordinatorMock!
    
    override func setUpWithError() throws {
        self.coordinator = ImportWalletCoordinatorMock()
        let vm = ImportWalletViewModel(validatorService: ValidatorServiceDummy())
                                           
        let vc = ImportWalletViewController(viewModel: vm, coordinator: self.coordinator)
        self.sut = vc
        self.sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }

    func test() throws {
        
        sut.addressTextView.text = "aaa"
        sut.onContinueButtonTapDo(self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.coordinator.buildHomeCalled, "true")
        }
    }

    final class ImportWalletCoordinatorMock: Coordinator, HomeBuilding {
        var childCoordinators: [Solboard.Coordinator] = []
        
        var navigationController: UINavigationController = UINavigationController()
        
        private(set) var startCalled = false
        private(set) var buildHomeCalled = false
        
        func start() {
            startCalled = true
        }
        
        func buildHome() {
            buildHomeCalled = true
        }
        
        
    }
    
    final class ValidatorServiceDummy: ValidatorServiceProtocol {
        func isValidAddress(_ address: String, completion: @escaping (Bool) -> Void) {
            if address == "aaa" {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}
