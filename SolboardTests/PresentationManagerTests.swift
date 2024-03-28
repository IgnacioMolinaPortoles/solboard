//
//  PresentationManagerTests.swift
//  SolboardTests
//
//  Created by Ignacio Molina Portoles on 28/03/2024.
//
import UIKit
import Foundation
import XCTest
@testable import Solboard

class PresentationManagerTests: XCTestCase {

    class LoginCoordinatorMock: LoginCoordinator {
        private(set) var starCalled: Bool = false

        override func start() {
            starCalled = true
        }
    }
    
    class HomeCoordinatorMock: HomeCoordinator {
        private(set) var starCalled: Bool = false
        
        override func start() {
            starCalled = true
        }
    }
    
    func testSetupInitialViewController_UserExists() {
        // Arrange
        let loginCoordinator = LoginCoordinatorMock(navigationController: UINavigationController())
        let homeCoordinator = HomeCoordinatorMock(navigationController: UINavigationController())
        
        let sut = makeSUT(hasUser: true, loginCoordinator: loginCoordinator, homeCoordinator: homeCoordinator)
        
        // Act
        let view = sut.getNavigation()
        view.loadViewIfNeeded()
        
        // Assert
        XCTAssertTrue(homeCoordinator.starCalled)
        XCTAssertFalse(loginCoordinator.starCalled)
    }
    
    func testSetupInitialViewController_NoUser() {
        // Arrange
        let loginCoordinator = LoginCoordinatorMock(navigationController: UINavigationController())
        let homeCoordinator = HomeCoordinatorMock(navigationController: UINavigationController())
        
        let sut = makeSUT(hasUser: false, loginCoordinator: loginCoordinator, homeCoordinator: homeCoordinator)
        
        // Act
        let view = sut.getNavigation()
        view.loadViewIfNeeded()
        
        // Assert
        XCTAssertTrue(loginCoordinator.starCalled)
        XCTAssertFalse(homeCoordinator.starCalled)
    }
    
    private func makeSUT(hasUser: Bool, loginCoordinator: Coordinator, homeCoordinator: Coordinator) -> PresentationManager {
        let dataManager = UserDataManagerMock(hasUser: hasUser)
        
        return PresentationManager(dataManager: dataManager,
                                      loginCoordinator: loginCoordinator,
                                      tabsCoordinators: [homeCoordinator])
    }
}
