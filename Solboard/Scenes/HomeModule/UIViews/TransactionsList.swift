//
//  TransactionsList.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 11/04/2024.
//

import SwiftUI
import Combine

class TransactionsListViewModel: ObservableObject {
    @Published var transactions: [TransactionViewModel]
    
    init(transactions: [TransactionViewModel]) {
        self.transactions = transactions
    }
    
    func updateTransactions(transactions: [TransactionViewModel]) {
        self.transactions = transactions
    }
}


struct TransactionsList: View {
    @ObservedObject var transactionsViewModel: TransactionsListViewModel
    var onTransactionTapDo: (String) -> Void
    var tableTitle: String
    
    init(transactionsViewModel: TransactionsListViewModel,
         onTransactionTapDo: @escaping (String) -> Void,
         tableTitle: String) {
        self.transactionsViewModel = transactionsViewModel
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
            ForEach(self.transactionsViewModel.transactions) { transaction in
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
    func addTransactionList(transactions: [TransactionViewModel],
                            onTransactionTapDo: @escaping (String) -> Void,
                            tableTitle: String) -> TransactionsListViewModel {
        let viewModel = TransactionsListViewModel(transactions: transactions)
        let view = TransactionsList(transactionsViewModel: viewModel,
                                    onTransactionTapDo: onTransactionTapDo, tableTitle: tableTitle)
        
        let hostingController = UIHostingController(rootView: view)
        hostingController.view.isOpaque = false
        hostingController.view.backgroundColor = UIColor.clear
        
        self.addSubview(hostingController.view)
        hostingController.view.attach(toView: self)
        self.backgroundColor = .clear
        self.isOpaque = false
        
        return viewModel
    }
}
