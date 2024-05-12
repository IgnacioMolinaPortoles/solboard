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
    @Published var searchText = ""

    var searchBarEnabled: Bool
    
    var filteredTransactions: [TransactionViewModel] {
        if searchText.isEmpty {
            return transactions
        } else {
            return filterTransactionsBySearch(transactions)
        }
    }
    
    init(transactions: [TransactionViewModel], searchBarEnabled: Bool = false) {
        self.transactions = transactions
        self.searchBarEnabled = searchBarEnabled
    }
    
    func updateTransactions(transactions: [TransactionViewModel]) {
        self.transactions = transactions
    }
    
    private func filterTransactionsBySearch(_ transactions: [TransactionViewModel]) -> [TransactionViewModel] {
        return transactions.filter { tx in
            tx.signatureHash.localizedCaseInsensitiveContains(searchText)
        }
    }
}


struct TransactionsList: View {
    @ObservedObject var vm: TransactionsListViewModel

    var onTransactionDetailTapDo: (String) -> Void
    var onShowAllDataTapDo: (() -> Void)?
    var tableTitle: String?
    
    var body: some View {
        if vm.transactions.isEmpty {
            LoadingView()
                .padding()
        } else {
            if let title = tableTitle {
                HStack {
                    Text(title)
                        .padding(.leading, 20)
                        .foregroundStyle(Color.textLightGray)
                    Spacer()
                }
            }
            
            List {
                ForEach(vm.filteredTransactions) { transaction in
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
                .listRowBackground(Color.backgroundDarkGray1C)
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
                    .listRowBackground(Color.backgroundDarkGray1C)
                }
            }
            .searchable(text: $vm.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Transaction address")
            .padding(.top, -35)
            .scrollDisabled(!vm.searchBarEnabled)
            .listSectionSpacing(12)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    let dummy = TransactionViewModel(signatureHash: "TX1231 SD",
                                     unixDate: Int(Date().timeIntervalSince1970))
    
    let vm =  TransactionsListViewModel(transactions: [dummy,
                                                       dummy,
                                                       dummy],
    searchBarEnabled: true)
    
    return TransactionsList(vm: vm,
                            onTransactionDetailTapDo: {_ in },
                            onShowAllDataTapDo: {
        print("si")
    })
}

extension UIView {
    func addTransactionList(transactions: [TransactionViewModel],
                            onTransactionDetailTapDo: @escaping (String) -> Void,
                            onShowAllDataTapDo: (() -> Void)?,
                            tableTitle: String? = nil) -> TransactionsListViewModel {
        let viewModel = TransactionsListViewModel(transactions: transactions)
        let view = TransactionsList(vm: viewModel,
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
