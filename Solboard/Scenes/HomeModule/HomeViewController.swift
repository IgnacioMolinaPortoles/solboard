//
//  HomeViewController.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 26/03/2024.
//

import UIKit
import SwiftUI

let address = "AUXVBHMKvW6arSPPNbjSuz8y3f6HA2p8YCcKLr8HBGdh"

final class HomeViewModel {
    private let assetServiceManager: AssetsServiceManagerProtocol
    private let transactionsService: TransactionsServiceProtocol

    
    var onTokensViewModelFetchedDo: (([TokenViewModel]?) -> Void)?
    var onBalanceFetchedDo: ((Double) -> Void)?
    var onTransactionsFetchedDo: (([TransactionViewModel]?) -> Void)?
    
    private var assetsItems: [AssetItem] = []
    private var transactions: [TransactionViewModel] = []
    
    init(assetServiceManager: AssetsServiceManagerProtocol,
         transactionsService: TransactionsServiceProtocol) {
        self.assetServiceManager = assetServiceManager
        self.transactionsService = transactionsService
    }
    
    func getFetchedAssets() -> [AssetItem] {
        assetsItems
    }
    
    func getFetchedTransactions() -> [TransactionViewModel] {
        transactions
    }
    
    func getTransactions() {
        transactionsService.getSignatures(address) { [weak self] transactions in
            self?.transactions = transactions
            self?.onTransactionsFetchedDo!(transactions)
        }
    }

    func getAssets() {
        assetServiceManager.getAssets { [weak self] assets in
            self?.assetsItems = assets
            
            let assetsVMArray = assets.map({ AssetItemViewModel(from: $0) })
            let totalBalance = assetsVMArray.reduce(0.0) { $0 + (Double(($1.balance ?? 0.0)) * ($1.pricePerToken ?? 0.0)) }
            
            self?.onBalanceFetchedDo?(totalBalance)
            self?.onTokensViewModelFetchedDo?(assetsVMArray.toTokenViewModel())
        }
    }
}

final class HomeViewController: UIViewController {

    @IBOutlet weak var titleScreenLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var transactionsLabel: UILabel!
    @IBOutlet weak var transactionsView: UIView!
    
    private let viewModel: HomeViewModel
    private let coordinator: (TransactionRouting & AssetRouting)
    
    init(viewModel: HomeViewModel = HomeViewModel(assetServiceManager: AssetsServiceManager(assetsService: AssetsService()),
                                                  transactionsService: TransactionsService()),
         coordinator: (TransactionRouting & AssetRouting)) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleScreenLabel.text = "Dashboard"
        balanceLabel.text = "Balance"
        transactionsLabel.text = "Transactions"
        
        bindBalanceLabel()
        addAndBindAssetBarChart()
        addAndBindTransactionsList()
        
        viewModel.getAssets()
        viewModel.getTransactions()
    }
    
    private func bindBalanceLabel() {
        viewModel.onBalanceFetchedDo = { [weak self] totalBalance in
            self?.balanceLabel.text = "Balance: $\(String(format: "%.2f", totalBalance))"
        }
    }
    
    private func addAndBindAssetBarChart() {
        let barchartViewModel = self.balanceView.addAssetBarChart(tokensData: [],
                                                                  onAssetTapDo: {
            self.coordinator.routeToAssetView(assets: self.viewModel.getFetchedAssets())
        })
        
        viewModel.onTokensViewModelFetchedDo = { (tokensVM) in
            barchartViewModel.updateTokens(tokens: tokensVM ?? [])
        }
    }
    
    private func addAndBindTransactionsList() {
        let transactionsViewModel = self.transactionsView.addTransactionList(transactions: [],
                                                                             onTransactionDetailTapDo: { [weak self] tx in
            self?.coordinator.routeToTransactionDetail(tx: tx)
        }, onShowAllDataTapDo: { [weak self] in
            self?.coordinator.routeToAllTransactions(txs: self?.viewModel.getFetchedTransactions() ?? [])
        },
                                                                             tableTitle: "Signature")
        
        
        viewModel.onTransactionsFetchedDo = { transactions in
            transactionsViewModel.updateTransactions(transactions: Array((transactions ?? []).prefix(5)))
        }
    }
}
