//
//  HomeTests.swift
//  SolboardTests
//
//  Created by Ignacio Molina Portoles on 10/04/2024.
//

import XCTest
@testable import Solboard

//Titulo pantalla
//Titulo de balance
//Subvista de grafico
//Titulo de transacciones
//Subvista de tabla

final class HomeTests: XCTestCase {

    var sut: HomeViewController!
    
    override func setUpWithError() throws {
        self.sut = HomeViewController()
        self.sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }
    
    func test_HomeVC_defaultUIValues() {
        XCTAssertEqual(sut.titleScreenLabel.text, "Dashboard")
        XCTAssertEqual(sut.balanceLabel.text, "Balance")
        XCTAssertEqual(sut.balanceView.subviews.count, 1)
        XCTAssertEqual(sut.transactionsLabel.text, "Transactions")
        XCTAssertEqual(sut.transactionsView.subviews.count, 1)
    }
    
    func testHomeVC_HasCorrectFirstSubtitle() {
        
    }
    
}
