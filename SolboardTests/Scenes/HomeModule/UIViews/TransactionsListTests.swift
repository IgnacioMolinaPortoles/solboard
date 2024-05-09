//
//  TransactionsListTests.swift
//  SolboardTests
//
//  Created by Ignacio Molina Portoles on 01/05/2024.
//

import Foundation
import XCTest
import SwiftUI
import Combine
@testable import Solboard

class TransactionViewModelTests: XCTestCase {
    
    // Prueba para verificar que `TransactionViewModel` crea correctamente los campos de presentableDate y shortSignature
    func testTransactionViewModel_CreatesCorrectShortSignatureAndPresentableDate() {
        // Arrange
        let signatureHash = "signatureHashExample"
        let unixDate = 1700000000  // Ejemplo de fecha Unix
        
        // Act
        let sut = TransactionViewModel(signatureHash: signatureHash, unixDate: unixDate)
        
        // Assert
        XCTAssertEqual(sut.signatureHash.shortSignature, "signatureHashExample".shortSignature, "shortSignature no es correcto")
        
        let expectedDate = DateParser.shared.getParsedDate(TimeInterval(unixDate))
        XCTAssertEqual(sut.unixDate.dayMonthYearDate, expectedDate, "presentableDate no es correcto")
    }
}


class TransactionsListTests: XCTestCase {
    
    // Prueba para verificar que `TransactionsList` se inicia correctamente con los parámetros proporcionados
    func testInit_StartsWithProvidedParameters() {
        // Arrange
        let transactionsViewModel = TransactionsListViewModel(transactions: [])
        let expectedTableTitle = "Transactions"
        var didTapTransaction = false
        
        // Act
        let sut = TransactionsList(transactionsViewModel: transactionsViewModel,
                                   onTransactionDetailTapDo: { _ in
                                       didTapTransaction = true
                                   },
                                   tableTitle: expectedTableTitle)
        
        // Assert
        XCTAssertEqual(sut.transactionsViewModel, transactionsViewModel, "El `TransactionsList` debería iniciarse con el `TransactionsListViewModel` proporcionado")
        XCTAssertEqual(sut.tableTitle, expectedTableTitle, "El `TransactionsList` debería iniciarse con el título de tabla proporcionado")
        XCTAssertFalse(didTapTransaction, "La transacción no debería haberse tocado inicialmente")
    }
    
    // Prueba para verificar que el callback `onTransactionTapDo` se ejecuta correctamente al seleccionar una transacción
    func testOnTransactionTapDo_CallsCallbackWhenTransactionTapped() {
        // Arrange
        let transactions = [
            TransactionViewModel(signatureHash: "signature1", unixDate: 1700000000)
        ]
        let transactionsViewModel = TransactionsListViewModel(transactions: transactions)
        var didTapTransaction = false
        
        // Act
        let sut = TransactionsList(transactionsViewModel: transactionsViewModel,
                                   onTransactionDetailTapDo: { signature in
                                       XCTAssertEqual(signature, "signature1", "Debería haber llamado al callback con la firma correcta")
                                       didTapTransaction = true
                                   },
                                   tableTitle: "Transactions")
        
        // Simula un tap en la transacción
        let tapTransaction = sut.transactionsViewModel.transactions.first!
        sut.onTransactionDetailTapDo(tapTransaction.signatureHash)
        
        // Assert
        XCTAssertTrue(didTapTransaction, "Debería haber llamado al callback `onTransactionTapDo` cuando se tocó la transacción")
    }
}
