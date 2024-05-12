//
//  TransactionDetailModuleTests.swift
//  SolboardTests
//
//  Created by Ignacio Molina Portoles on 08/05/2024.
//

import XCTest
@testable import Solboard

final class TransactionDetailModuleTests: XCTestCase {

    var txResponse: GetSignatureResponse!
    
    override func setUpWithError() throws {
        self.txResponse = TransactionDummyFactory.getTokenResponse()
    }
    
    func testModelDecoding() throws {
        let txResponseSuccess = TransactionDummyFactory.getTokenResponse()
        XCTAssertNotNil(txResponseSuccess)
    }
    
    func testViewModel_HasValidSignature() throws {
        let sut = makeSUT()
        XCTAssertEqual(sut.signature, "ru1YT52k3jhCZiczamXWUtzFbRvTo4pbxonhRaEszRDkz7mLHxv9PWMCSq3UHgyDBfsRjmjUpUZH3LXhcv1J7tU")
    }
    
    func testViewModel_HasCorrectBlock() throws {
        let sut = makeSUT(txResponse: txResponse)
        
        sut.fetch()
        
        XCTAssertEqual(sut.block, "#264673157", "Wrong block from fetched data")
    }
    
    func testViewModel_HasCorrectDate() throws {
        let sut = makeSUT(txResponse: txResponse)
        
        sut.fetch()
        
        XCTAssertEqual(sut.date, "08/05/2024", "Wrong date from fetched data")
    }

    func testViewModel_HasSuccessStatus() throws {
        let sut = makeSUT(txResponse: txResponse)
        
        sut.fetch()
        let err = txResponse.result?.meta?.err
        
        XCTAssertNil(err)
        XCTAssertEqual(sut.status, .success)
    }
    
    func testViewModel_HasCorrectSigner() throws {
        let sut = makeSUT(txResponse: txResponse)
        
        sut.fetch()
        
        XCTAssertEqual(sut.signer, "phxBcughCYKiYJxx9kYEkyqoAUL2RD3vyxSaL1gZRNG")
    }
    
    func testViewModel_HasCorrectFee() throws {
        let sut = makeSUT(txResponse: txResponse)
        
        sut.fetch()
        
        XCTAssertEqual(sut.fee, "0,000009377 SOL")
    }
    
    func testViewModel_HasBalanceChanges() throws {
        let sut = makeSUT(txResponse: txResponse)
        
        sut.fetch()
        
        guard sut.balanceChanges.first != nil else {
            XCTFail("Should have at least 1 balance change")
            return
        }
    }
    
    func testViewModel_HasCorrectBalanceChange() throws {
        let sut = makeSUT(txResponse: txResponse)
        
        sut.fetch()
        let expected = BalanceChange(address: "phxBcughCYKiYJxx9kYEkyqoAUL2RD3vyxSaL1gZRNG",
                                     balanceBefore: 5.241175652,
                                     balanceAfter: 5.241166275,
                                     change: "- 0,000009")
        
        XCTAssertEqual(sut.balanceChanges.first!.address, expected.address, "Wrong balance change")
        XCTAssertEqual(sut.balanceChanges.first!.balanceBefore, expected.balanceBefore, "Wrong balance change")
        XCTAssertEqual(sut.balanceChanges.first!.balanceAfter, expected.balanceAfter, "Wrong balance change")
        XCTAssertEqual(sut.balanceChanges.first!.change, expected.change, "Wrong balance change")
    }
    
    func testViewModel_HasTokenChanges() throws {
        let sut = makeSUT(txResponse: txResponse)
        
        sut.fetch()
        
        guard sut.tokenChanges.first != nil else {
            XCTFail("Should have at least 1 token change")
            return
        }
    }
    
    func testViewModel_HasCorrectTokenChange() throws {
        let sut = makeSUT(txResponse: txResponse)
        
        sut.fetch()
        let expected = TokenChange(address: "71rfmyvgBXNcY7CsMkbJdV14afUEW4y1giGPsZ4maWMZ",
                                   owner: "phxBcughCYKiYJxx9kYEkyqoAUL2RD3vyxSaL1gZRNG",
                                   balanceBefore: 10212.578525,
                                   balanceAfter: 10216.302525,
                                   change: "+ 3,724",
                                   token: "EKpQGSJtjMFqKZ9KQanSqYXRcF8fBopzLHYxdM65zcjm")
        
        XCTAssertEqual(sut.tokenChanges.first!.address, expected.address, "Wrong balance change")
        XCTAssertEqual(sut.tokenChanges.first!.owner, expected.owner, "Wrong balance change")
        XCTAssertEqual(sut.tokenChanges.first!.balanceBefore, expected.balanceBefore, "Wrong balance change")
        XCTAssertEqual(sut.tokenChanges.first!.balanceAfter, expected.balanceAfter, "Wrong balance change")
        XCTAssertEqual(sut.tokenChanges.first!.change, expected.change, "Wrong balance change")
    }
    
    func testViewModel_HasErrorStatus() throws {
        let txFailResponse = TransactionDummyFactory.getFailResponse()!
        XCTAssertNotNil(txFailResponse)
        let sut = makeSUT(txResponse: txFailResponse)
        
        sut.fetch()
        let err = txFailResponse.result?.meta?.err
        
        XCTAssertNotNil(err)
        XCTAssertEqual(sut.status, .failed("6001"))
    }
}


// MARK: Helpers

extension TransactionDetailModuleTests {
    
    func makeSUT() -> TransactionDetailViewModel {
        let txResponse = TransactionDummyFactory.getResponse()
        let signature = "ru1YT52k3jhCZiczamXWUtzFbRvTo4pbxonhRaEszRDkz7mLHxv9PWMCSq3UHgyDBfsRjmjUpUZH3LXhcv1J7tU"
        let txService = TransactionServiceMock(response: txResponse!)
        
        return makeSUT(signature: signature, transactionsService: txService)
    }
    
    func makeSUT(txResponse: GetSignatureResponse) -> TransactionDetailViewModel {
        let signature = "ru1YT52k3jhCZiczamXWUtzFbRvTo4pbxonhRaEszRDkz7mLHxv9PWMCSq3UHgyDBfsRjmjUpUZH3LXhcv1J7tU"
        let txService = TransactionServiceMock(response: txResponse)
        
        return makeSUT(signature: signature, transactionsService: txService)
    }
    
    func makeSUT(signature: String, transactionsService: TransactionsServiceProtocol) -> TransactionDetailViewModel {
        return TransactionDetailViewModel(transactionService: transactionsService,
                                          signature: signature, onTransactionTapDo: {})
    }
    
    class TransactionServiceMock: TransactionsServiceProtocol {
        let response: GetSignatureResponse
        
        init(response: GetSignatureResponse) {
            self.response = response
        }
        
        func getSignatures(_ address: String, completion: @escaping ([Solboard.TransactionViewModel]) -> Void) {
            completion([])
        }
        
        func getTransaction(_ tx: String, completion: @escaping (Solboard.GetSignatureResponse?) -> Void) {
            completion(self.response)
        }
    }
}
