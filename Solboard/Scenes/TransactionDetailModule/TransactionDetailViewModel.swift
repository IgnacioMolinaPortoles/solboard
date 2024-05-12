//
//  TransactionDetailItemViewModel.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 05/05/2024.
//

import Foundation

enum TransactionStatus: Equatable {
    case success
    case failed(String)
}

struct BalanceChange: Hashable, Identifiable {
    var id = UUID()
    
    let address: String
    let balanceBefore: Double
    let balanceAfter: Double
    let change: String
    
    init(address: String, balanceBefore: Double, balanceAfter: Double, change: String) {
        self.address = address
        self.balanceBefore = balanceBefore
        self.balanceAfter = balanceAfter
        self.change = change
    }
    
    init() {
        self.id = UUID()
        self.address = ""
        self.balanceBefore = 0.0
        self.balanceAfter = 0.0
        self.change = ""
    }
}

struct TokenChange: Hashable, Identifiable {
    var id = UUID()

    let address: String
    let owner: String
    let balanceBefore: Double
    let balanceAfter: Double
    let change: String
    let token: String
    
    init(address: String, owner: String, balanceBefore: Double, balanceAfter: Double, change: String, token: String) {
        self.address = address
        self.owner = owner
        self.balanceBefore = balanceBefore
        self.balanceAfter = balanceAfter
        self.change = change
        self.token = token
    }
    
    init() {
        self.address = ""
        self.owner = ""
        self.balanceBefore = 0.0
        self.balanceAfter = 0.0
        self.change = ""
        self.token = ""
    }
}

class TransactionDetailViewModel: ObservableObject {
    @Published var signature: String
    @Published var block: String? = nil
    @Published var date: String? = nil
    @Published var status: TransactionStatus? = nil
    @Published var signer: String? = nil
    @Published var fee: String? = nil
    @Published var balanceChanges: [BalanceChange] = []
    @Published var tokenChanges: [TokenChange] = []
    @Published var isLoading: Bool = true
    
    var onTransactionTapDo: (() -> Void)?
    
    var transactionService: TransactionsServiceProtocol
    
    init(transactionService: TransactionsServiceProtocol, 
         signature: String,
         onTransactionTapDo: (() -> Void)?) {
        self.transactionService = transactionService
        self.signature = signature
        self.onTransactionTapDo = onTransactionTapDo
    }
    
    func fetch() {
        self.transactionService.getTransaction(self.signature) { txResponse in
            
            if let block = txResponse?.result?.slot {
                self.block = "#\(block)"
            } else {
                self.block = nil
            }
            
            self.date = txResponse?.result?.blockTime?.dayMonthYearDate
            
            if let err = txResponse?.result?.meta?.err?.instructionError?.last?.getStringValue() {
                self.status = .failed(err)
            } else {
                self.status = .success
            }
            
            self.signer = txResponse?.result?.transaction?.message?.accountKeys?.first
            self.fee = txResponse?.result?.meta?.fee?.parseFee()
            self.balanceChanges = []
            
            if let amountOfAddress = txResponse?.result?.transaction?.message?.accountKeys?.count, amountOfAddress > 0 {
                for index in 0..<amountOfAddress {
                    let addresses = txResponse?.result?.transaction?.message?.accountKeys ?? []
                    let preBalances = txResponse?.result?.meta?.preBalances ?? []
                    let postBalances = txResponse?.result?.meta?.postBalances ?? []
                    
                    let preBalance = Double(preBalances[index]) / Constants.lamports
                    let postBalance = Double(postBalances[index]) / Constants.lamports
                    let change = (postBalance - preBalance) == 0.0 ? "0" : "\((postBalance - preBalance).allDecimals(maximumFractionDigits: 6))".replacingOccurrences(of: "-", with: "- ")
                    
                    let balanceChange = BalanceChange(address: addresses[index],
                                                      balanceBefore: preBalance,
                                                      balanceAfter: postBalance,
                                                      change: change)
                    
                    self.balanceChanges.append(balanceChange)
                }
            }
            
            self.tokenChanges = []
            
            if let amountOfTokenChanges = txResponse?.result?.meta?.preTokenBalances?.count, amountOfTokenChanges > 0 {
                for index in 0..<amountOfTokenChanges {
                    let addresses = txResponse?.result?.transaction?.message?.accountKeys ?? []
                    let preTokenBalance = txResponse?.result?.meta?.preTokenBalances ?? []
                    let postTokenBalance = txResponse?.result?.meta?.postTokenBalances ?? []
                    
                    let postBalanceInfo: GetSignatureTokenBalance? = postTokenBalance.count > index ? postTokenBalance[index] : nil
                    
                    var address = "-"
                    
                    if let index = postBalanceInfo?.accountIndex, addresses.count > index {
                        address = addresses[index]
                    }
                    
                    let balanceBefore = preTokenBalance[index].uiTokenAmount?.uiAmount ?? 0.0
                    let balanceAfter = postBalanceInfo?.uiTokenAmount?.uiAmount ?? 0.0
                    let change = (balanceAfter - balanceBefore) == 0.0 ? "0" : "\((balanceAfter - balanceBefore).allDecimals(maximumFractionDigits: 6))"
                        .replacingOccurrences(of: "-", with: "- ").includeAddSymbol
                    
                    let tokenChange = TokenChange(address: address,
                                                  owner: postBalanceInfo?.owner ?? "-",
                                                  balanceBefore: balanceBefore,
                                                  balanceAfter: balanceAfter,
                                                  change: change,
                                                  token: postBalanceInfo?.mint ?? "-")
                    
                    self.tokenChanges.append(tokenChange)
                }
            }
            
            self.isLoading = false
        }
    }
}
