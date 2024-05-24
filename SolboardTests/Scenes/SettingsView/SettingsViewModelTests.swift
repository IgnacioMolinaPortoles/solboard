//
//  SettingsViewModelTests.swift
//  SolboardTests
//
//  Created by Ignacio Molina Portoles on 22/05/2024.
//

import XCTest
@testable import Solboard

final class SettingsViewModelTests: XCTestCase {

    func testLogOut_ShouldClearUser() {
        let dataManager = MockDataManager()
        _ = dataManager.create(address: "ASD123!@#")

        let sut = makeSUT(dataManager: dataManager)
        
        sut.logout()
        
        XCTAssertNil(dataManager.getUser())
    }
    
    func testNewValidAddress_shouldBeSavedInCoreData() {
        let dataManager = MockDataManager()
        _ = dataManager.create(address: "")

        let sut = makeSUT(dataManager: dataManager)
        let address = "ASD123!@#"
        
        XCTAssertEqual(dataManager.getUser()?.address, "")
        
        sut.isValidAddress(address) { isValid in
            XCTAssertTrue(dataManager.getUser()?.address ?? "" == address)
        }
    }

    func testNewAddress_isValidAddress() {
        let sut = makeSUT()
        let address = "ASD123!@#"
        
        sut.isValidAddress(address) { isValid in
            XCTAssertTrue(isValid)
        }
    }
    
    func testNewAddress_isInvalidAddress() {
        let sut = makeSUT()
        let address = "asd123"
        
        sut.isValidAddress(address) { isValid in
            XCTAssertFalse(isValid)
        }
    }
}

extension SettingsViewModelTests {
    func makeSUT(service: ValidatorServiceProtocol = MockValidatorService(),
                 dataManager: any UserPersistenceProtocol = MockDataManager()) -> SettingsViewModel {
        let sut = SettingsViewModel(dataManager: dataManager,
                                    validatorService: service,
                                    alertManager: AlertManagerMock())
        return sut
    }
    
    final class MockValidatorService: ValidatorServiceProtocol {
        private(set) var isValidAddressServiceCalled = false
        
        func isValidAddress(_ address: String, completion: @escaping (Bool) -> Void) {
            isValidAddressServiceCalled = true
            completion(address == "ASD123!@#")
        }
    }
}

struct MockUserDataModel {
    var id: Int
    var address: String
}

final class MockDataManager: UserPersistenceProtocol {
    func delete(item: MockUserDataModel) -> Bool {
        self.user = nil
        return true
    }
    
    typealias DataType = MockUserDataModel
    
    private(set) var user: MockUserDataModel? = nil
    
    
    func getUser() -> MockUserDataModel? {
        self.user
    }
    
    func update(item: MockUserDataModel, newAddress: String) -> Bool {
        self.user?.address = newAddress
        return true
    }
    
    func create(address: String) -> Bool {
        self.user = MockUserDataModel(id: 1, address: address)
        return true
    }
}
