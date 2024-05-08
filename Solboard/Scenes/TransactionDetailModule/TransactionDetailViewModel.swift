//
//  TransactionDetailItemViewModel.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 05/05/2024.
//

import Foundation

struct TransactionDetailItemViewModel {
    let signature: String
    let block: Int
    let timestamp: Int?
    let status: String
    let signer: String
    let fee: Double
//    let balanceChanges: [BalanceChange]
//    let tokenChanges: [TokenChange]
    let error: String?
}

extension TransactionDetailItemViewModel {
    init(from response: TransactionResponse) {
        let result = response.result
        
        let transaction = result.transaction
        self.signature = transaction.signatures.first ?? ""
        self.block = result.slot
        self.timestamp = result.blockTime
        self.signer = result.transaction.message.accountKeys.first ?? "Unknow"
        
        if let meta = result.meta {
            let status = meta.status
            if status.Ok != nil {
                self.status = "Ok"
                self.error = nil
            } else if let err = status.Err {
                self.status = "Err"
                self.error = err.InstructionError?.first?.extractErrorDescription()
            } else {
                self.status = "Unknown"
                self.error = nil
            }
            
            self.fee = Double(meta.fee ?? 0)
            self.balanceChanges = TransactionChangesMapper.extractBalanceChanges(meta: meta)
            self.tokenChanges = TransactionChangesMapper.extractTokenChanges(meta: meta)
        } else {
            self.fee = 0
            self.status = "Unknown"
            self.error = nil
            self.balanceChanges = []
            self.tokenChanges = []
        }
    }
}

struct BalanceChange: Hashable {
    let address: String
    let balanceBefore: Double
    let balanceAfter: Double
}

struct TokenChange: Hashable {
    let mint: String
    let owner: String
    let balanceBefore: Double
    let balanceAfter: Double
}

extension InstructionErrorType {
    func extractErrorDescription() -> String {
        switch self {
        case .simple(let code):
            return "Error code: \(code)"
        case .detailed(let code, let customError):
            return "Error code: \(code), Custom error code: \(customError.custom)"
        }
    }
}

struct TransactionChangesMapper {
    static func extractBalanceChanges(meta: TransactionMeta?) -> [BalanceChange] {
        guard let meta = meta else { return [] }
        
        let preBalances = meta.preBalances
        let postBalances = meta.postBalances
        
        return zip(preBalances, postBalances).enumerated().map { (index, balances) in
            let change = Int64(balances.1) - Int64(balances.0)
            return BalanceChange(
                address: meta.innerInstructions.first?.instructions.first?.accounts[index].description ?? "",
                balanceBefore: balances.0,
                balanceAfter: balances.1,
                change: change
            )
        }
    }
    
    static func extractTokenChanges(meta: TransactionMeta?) -> [TokenChange] {
        guard let meta = meta else { return [] }
        
        let preTokenBalances = meta.preTokenBalances
        let postTokenBalances = meta.postTokenBalances
        
        return zip(preTokenBalances, postTokenBalances).map { (preToken, postToken) in
            let balanceBefore = preToken.uiTokenAmount.uiAmount
            let balanceAfter = postToken.uiTokenAmount.uiAmount
            
            return TokenChange(
                mint: preToken.mint,
                owner: preToken.owner,
                balanceBefore: balanceBefore,
                balanceAfter: balanceAfter,
                change: balanceAfter - balanceBefore
            )
        }
    }
}
