//
//  BalanceChangeSheet.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 14/05/2024.
//

import SwiftUI

struct BalanceChangeSheet: View {
    @Binding var selectedBalanceChange: BalanceChange
    
    var body: some View {
        VStack {
            Text("SOL Balance Change")
                .fontWeight(.bold)
                .font(.system(size: 25))
                .foregroundStyle(.white)
                .padding(.top, 20)
            
            Divider()
                .background(Color.backgroundDarkGray2D)
                .padding(.horizontal, 20)
                .padding(.bottom, 18)
            
            List {
                TransactionDetailSection(backgroundColor: .backgroundDarkGray2D,
                                         listRowSeparatorTint: .backgroundDarkGray5D,
                                         content: {
                    TransactionOverviewItem(title: "Address",
                                            value: selectedBalanceChange.address.shortSignature)
                    
                    TransactionOverviewItem(title: "Balance before",
                                            value: selectedBalanceChange.balanceBefore.allDecimals())
                    
                    TransactionOverviewItem(title: "Balance after",
                                            value: selectedBalanceChange.balanceAfter.allDecimals())
                    
                    TransactionOverviewItem(title: "Change",
                                            value: selectedBalanceChange.change, valueColor: selectedBalanceChange.change == "0" ? .white : selectedBalanceChange.change.contains("- ") ? ._red : ._green)
                    
                })
            }
            .padding(.top, -40)
            .scrollDisabled(true)
            
        }
        .presentationDetents([.height(300)])
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.backgroundDarkGray1C)    }
}

//#Preview {
//    @Binding var change = BalanceChange()
//    return BalanceChangeSheet(selectedBalanceChange: change)
//}
