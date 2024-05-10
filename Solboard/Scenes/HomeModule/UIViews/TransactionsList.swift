//
//  TransactionsList.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 11/04/2024.
//

import SwiftUI
import Combine

class TransactionsListViewModel: ObservableObject, Equatable {
    private var id: UUID = UUID()
    
    static func == (lhs: TransactionsListViewModel, rhs: TransactionsListViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
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
    var onTransactionDetailTapDo: (String) -> Void
    var onShowAllDataTapDo: (() -> Void)?
    var tableTitle: String?
    
    var body: some View {
        
        if let title = tableTitle {
            HStack {
                Text(title)
                    .padding(.leading, 20)
                    .foregroundStyle(Color.textLightGray)
                Spacer()
            }
        }
        
        List {
            ForEach(self.transactionsViewModel.transactions) { transaction in
                HStack {
                    Text("\(transaction.signatureHash.shortSignature)")
                        .foregroundStyle(.white)
                    Spacer()
                    Text("\(transaction.unixDate.presentableDate)")
                        .foregroundStyle(Color.textLightGray)
                    Image(.chevronRight)
                    
                }
                .onTapGesture {
                    onTransactionDetailTapDo(transaction.signatureHash)
                }
            }
            .listRowBackground(Color.backgroundDarkGray)
            .listRowSeparatorTint(Color.listSeparatorDarkGray)
            
            if let onTapDo = onShowAllDataTapDo {
                Section() {
                    HStack {
                        Text("Show All Data")
                            .foregroundStyle(.white)
                        Spacer()
                        Image(.chevronRight)
                    }
                    .onTapGesture {
                        onTapDo()
                    }
                }
                .listRowBackground(Color.backgroundDarkGray)
            }
        }
        .padding(.top, -35)
        .scrollDisabled(false)
        .listSectionSpacing(12)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    let dummy = TransactionViewModel(signatureHash: "ASD SD",
                                     unixDate: Int(Date().timeIntervalSince1970))
    
    let vm =  TransactionsListViewModel(transactions: [dummy,
                                                       dummy,
                                                       dummy] )
    
    return TransactionsList(transactionsViewModel: vm,
                            onTransactionDetailTapDo: {_ in },
                            onShowAllDataTapDo: {
        print("si")
    },
                            tableTitle: "Signatures")
}

extension UIView {
    func addTransactionList(transactions: [TransactionViewModel],
                            onTransactionDetailTapDo: @escaping (String) -> Void,
                            onShowAllDataTapDo: (() -> Void)?,
                            tableTitle: String?) -> TransactionsListViewModel {
        let viewModel = TransactionsListViewModel(transactions: transactions)
        let view = TransactionsList(transactionsViewModel: viewModel,
                                    onTransactionDetailTapDo: onTransactionDetailTapDo,
                                    onShowAllDataTapDo: onShowAllDataTapDo,
                                    tableTitle: tableTitle)
        
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
