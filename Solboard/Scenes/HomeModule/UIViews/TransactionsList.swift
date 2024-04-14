//
//  TransactionsList.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 11/04/2024.
//

import SwiftUI

//let mockedTransactions = [
//    TransactionViewModel(name: "Mint to collection v1", date: "12/02/2023"),
//    TransactionViewModel(name: "Mint to null", date: "11/04/2022"),
//    TransactionViewModel(name: "Receive SOL", date: "22/03/2023"),
//    TransactionViewModel(name: "Mint", date: "02/02/2021"),
//    TransactionViewModel(name: "Send USDT", date: "20/01/2023"),
//    TransactionViewModel(name: "Mint", date: "02/02/2021")
//]

struct TransactionsList: View {
    var transaction: [TransactionViewModel] = []
    var onTransactionTapDo: (String) -> Void
    var tableTitle: String
    
    init(transaction: [TransactionViewModel], 
         onTransactionTapDo: @escaping (String) -> Void,
         tableTitle: String) {
        self.transaction = transaction
        self.onTransactionTapDo = onTransactionTapDo
        self.tableTitle = tableTitle
    }
    
    var body: some View {
        
        HStack {
            Text(tableTitle)
                .padding(.leading, 20)
                .foregroundStyle(Color.textLightGray)
            Spacer()
        }
        
        List {
            ForEach(self.transaction) { transaction in
                HStack {
                    Text("\(transaction.shortSignature)")
                        .foregroundStyle(.white)
                    Spacer()
                    Text("\(transaction.presentableDate)")
                        .foregroundStyle(Color.textLightGray)
                    Image(.chevronRight)
                    
                }
                .onTapGesture {
                    onTransactionTapDo(transaction.signatureHash)
                }
                
            }
            .listRowBackground(Color.backgroundDarkGray)
        }
        .listStyle(.plain)
        .scrollDisabled(true)
        .background(Color.backgroundDarkGray)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        
        
    }
}

//#Preview {
//    TransactionsList(transaction: [], onTransactionTapDo: {}, tableTitle: "ASD")
//}

extension UIView {
    func addTransactionList(transaction: [TransactionViewModel],
                            onTransactionTapDo: @escaping (String) -> Void,
                            tableTitle: String) {
        let view = TransactionsList(transaction: transaction,
                                    onTransactionTapDo: onTransactionTapDo, tableTitle: tableTitle)
        
        let hostingController = UIHostingController(rootView: view)
        hostingController.view.isOpaque = false
        hostingController.view.backgroundColor = UIColor.clear
        
        self.addSubview(hostingController.view)
        hostingController.view.attach(toView: self)
        self.backgroundColor = .clear
        self.isOpaque = false
    }
}
