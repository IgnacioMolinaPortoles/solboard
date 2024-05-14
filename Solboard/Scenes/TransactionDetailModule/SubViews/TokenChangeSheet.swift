//
//  TokenChangeSheet.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 14/05/2024.
//

import SwiftUI

struct TokenChangeSheet: View {
    @Binding var selectedTokenChange: TokenChange
    
    var body: some View {
        VStack {
            Text("Token Balance Change")
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
                                            value: selectedTokenChange.address.shortSignature)
                    
                    TransactionOverviewItem(title: "Owner",
                                            value: selectedTokenChange.owner.shortSignature)
                    
                    TransactionOverviewItem(title: "Balance before",
                                            value: selectedTokenChange.balanceBefore.allDecimals())
                    
                    TransactionOverviewItem(title: "Balance after",
                                            value: selectedTokenChange.balanceAfter.allDecimals())
                    
                    TransactionOverviewItem(title: "Change",
                                            value: selectedTokenChange.change, valueColor: selectedTokenChange.change == "0" ? .white : selectedTokenChange.change.contains("- ") ? ._red : ._green)
                    
                    TransactionOverviewItem(title: "Token",
                                            value: selectedTokenChange.token.shortSignature)
                })
            }
            .padding(.top, -40)
            .scrollDisabled(true)
            
        }
        .presentationDetents([.medium])
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.backgroundDarkGray1C)    }
}

//#Preview {
//    TokenChangeSheet()
//}
