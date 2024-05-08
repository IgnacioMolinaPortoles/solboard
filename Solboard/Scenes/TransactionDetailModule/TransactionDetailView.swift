//
//  TransactionDetailView.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 05/05/2024.
//

import SwiftUI

struct TransactionOverviewItem: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
    }
}

struct TransactionDetailView: View {
    let transaction: TransactionDetailItemViewModel
    
    var body: some View {
        VStack {
            List {
                
                Section() {
                    TransactionOverviewItem(title: "Signature", 
                                            value: transaction.signature.shortSignature)
                    TransactionOverviewItem(title: "Block",
                                            value: "#\(transaction.block)")
                    TransactionOverviewItem(title: "Timestamp",
                                            value: (transaction.timestamp ?? 0).dayMonthYearDate)
                    TransactionOverviewItem(title: "Result",
                                            value: transaction.status)
                    TransactionOverviewItem(title: "Signer",
                                            value: transaction.signer.shortSignature)
                    TransactionOverviewItem(title: "Fee",
                                            value: "SOL \(transaction.fee.allDecimals())")
                }
                .listRowBackground(Color.backgroundDarkGray)
                .listRowSeparatorTint(Color.listSeparatorDarkGray)
                
            }
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            
        }
        .navigationBarTitle("Transaction Detail", displayMode: .inline)
        .background(.black)
        .foregroundStyle(.white)
    }
}

#Preview {
    let exampleTransaction = TransactionDetailItemViewModel(
        signature: "5MSfDbo2aiujjaSiaPFRzSE2rjMsEQXmvsA74x6cFrbYKBFx6cQ69TubZG24o4VWdXbnsMxEgSBe857gQ65JiDRh",
        block: 264081291,
        timestamp: Int(Date().timeIntervalSince1970),
        status: "Success", 
        signer: "3UVYmECPPMZSCqWKfENfuoTv51fTDTWicX9xmBD2euKe", 
        fee: (5000 / 10000000000),
        balanceChanges:  [
            BalanceChange(
                address: "3UVYmECPPMZSCqWKfENfuoTv51fTDTWicX9xmBD2euKe",
                balanceBefore: 499998937500,
                balanceAfter: 499998932500, 
                change: 10
            ),
            BalanceChange(
                address: "AjozzgE83A3x1sHNUR64hfH7zaEBWeMaFuAN9kQgujrc",
                balanceBefore: 26858640,
                balanceAfter: 26858640, 
                change: 10
            )
            // Agrega más BalanceChange si es necesario
        ],
        tokenChanges: [
            TokenChange(
                mint: "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v",
                owner: "kpqUj83k4ieDRZjh7HMqrjkb5tkn84xy642t4Zm1WKe",
                balanceBefore: 35555428573,
                balanceAfter: 35555428573,
                change: 10
            ),
            TokenChange(
                mint: "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v",
                owner: "kpqUj83k4ieDRZjh7HMqrjkb5tkn84xy642t4Zm1WKe",
                balanceBefore: 35555428573,
                balanceAfter: 35555428573,
                change: 10
            ),
        ],
        error: nil
    )
    
    // Inicializar TransactionDetailView con datos de ejemplo
    return TransactionDetailView(transaction: exampleTransaction)
}
