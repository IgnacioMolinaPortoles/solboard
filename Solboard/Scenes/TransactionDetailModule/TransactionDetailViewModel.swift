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
}

struct TokenChange: Hashable, Identifiable {
    var id = UUID()

    let address: String
    let owner: String
    let balanceBefore: Double
    let balanceAfter: Double
    let change: String
    let token: String
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
    
    var transactionService: TransactionsServiceProtocol
    
    init(transactionService: TransactionsServiceProtocol, signature: String) {
        self.transactionService = transactionService
        self.signature = signature
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
                    let change = "\((postBalance - preBalance).allDecimals(maximumFractionDigits: 6))".replacingOccurrences(of: "-", with: "- ")
                    
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
                    let change = "\((balanceAfter - balanceBefore).allDecimals(maximumFractionDigits: 6))"
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
        }
    }
}



//extension TransactionDetailItemViewModel {
//    init(from response: TransactionResponse) {
//        let result = response.result
//        
//        let transaction = result.transaction
//        self.signature = transaction.signatures.first ?? ""
//        self.block = result.slot
//        self.timestamp = result.blockTime
//        self.signer = result.transaction.message.accountKeys.first ?? "Unknow"
//        
//        if let meta = result.meta {
//            let status = meta.status
//            if status.Ok != nil {
//                self.status = "Ok"
//                self.error = nil
//            } else if let err = status.Err {
//                self.status = "Err"
//                self.error = err.InstructionError?.first?.extractErrorDescription()
//            } else {
//                self.status = "Unknown"
//                self.error = nil
//            }
//            
//            self.fee = Double(meta.fee ?? 0)
//            self.balanceChanges = TransactionChangesMapper.extractBalanceChanges(meta: meta)
//            self.tokenChanges = TransactionChangesMapper.extractTokenChanges(meta: meta)
//        } else {
//            self.fee = 0
//            self.status = "Unknown"
//            self.error = nil
//            self.balanceChanges = []
//            self.tokenChanges = []
//        }
//    }
//}
//

//
//extension InstructionErrorType {
//    func extractErrorDescription() -> String {
//        switch self {
//        case .simple(let code):
//            return "Error code: \(code)"
//        case .detailed(let code, let customError):
//            return "Error code: \(code), Custom error code: \(customError.custom)"
//        }
//    }
//}
//
//struct TransactionChangesMapper {
//    static func extractBalanceChanges(meta: TransactionMeta?) -> [BalanceChange] {
//        guard let meta = meta else { return [] }
//        
//        let preBalances = meta.preBalances
//        let postBalances = meta.postBalances
//        
//        return zip(preBalances, postBalances).enumerated().map { (index, balances) in
//            let change = Int64(balances.1) - Int64(balances.0)
//            return BalanceChange(
//                address: meta.innerInstructions.first?.instructions.first?.accounts[index].description ?? "",
//                balanceBefore: balances.0,
//                balanceAfter: balances.1,
//                change: change
//            )
//        }
//    }
//    
//    static func extractTokenChanges(meta: TransactionMeta?) -> [TokenChange] {
//        guard let meta = meta else { return [] }
//        
//        let preTokenBalances = meta.preTokenBalances
//        let postTokenBalances = meta.postTokenBalances
//        
//        return zip(preTokenBalances, postTokenBalances).map { (preToken, postToken) in
//            let balanceBefore = preToken.uiTokenAmount.uiAmount
//            let balanceAfter = postToken.uiTokenAmount.uiAmount
//            
//            return TokenChange(
//                mint: preToken.mint,
//                owner: preToken.owner,
//                balanceBefore: balanceBefore,
//                balanceAfter: balanceAfter,
//                change: balanceAfter - balanceBefore
//            )
//        }
//    }
//}
