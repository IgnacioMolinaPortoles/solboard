//
//  HomeViewController.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 26/03/2024.
//

import UIKit
import SwiftUI

//let address = "AUXVBHMKvW6arSPPNbjSuz8y3f6HA2p8YCcKLr8HBGdh"
// AVUCZyuT35YSuj4RH7fwiyPu82Djn2Hfg7y2ND2XcnZH

final class HomeViewModel {
    private let assetServiceManager: AssetsServiceManagerProtocol
    private let transactionsService: TransactionsServiceProtocol
    private let dataManager: UserCoreDataManager?
    
    var onTokensViewModelFetchedDo: (([TokenViewModel]?) -> Void)?
    var onBalanceFetchedDo: ((Double) -> Void)?
    var onTransactionsFetchedDo: (([TransactionViewModel]?) -> Void)?
    
    private var assetsItems: [AssetItem] = []
    private var transactions: [TransactionViewModel] = []
    
    init(assetServiceManager: AssetsServiceManagerProtocol,
         transactionsService: TransactionsServiceProtocol,
         dataManager: any UserPersistenceProtocol) {
        self.assetServiceManager = assetServiceManager
        self.transactionsService = transactionsService
        self.dataManager = dataManager as? UserCoreDataManager
    }
    
    func getFetchedAssets() -> [AssetItem] {
        assetsItems
    }
    
    func getFetchedTransactions() -> [TransactionViewModel] {
        transactions
    }
    
    func getTransactions() {
        guard let address = dataManager?.getUser()?.address else {
            self.onTransactionsFetchedDo?([])
            return
        }
        
        transactionsService.getSignatures(address) { [weak self] transactions in
            self?.transactions = transactions
            self?.onTransactionsFetchedDo?(transactions)
        }
    }

    func getAssets() {
        guard let address = dataManager?.getUser()?.address else {
            self.onBalanceFetchedDo?(0.0)
            self.onTokensViewModelFetchedDo?([])
            return
        }
        
        assetServiceManager.getAssets(address) { [weak self] assets in
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
    @IBOutlet weak var userImage: UIImageView!
    
    private let viewModel: HomeViewModel
    private let coordinator: (TransactionRouting & AssetRouting & SettingsRouting)
    
    init(viewModel: HomeViewModel,
         coordinator: (TransactionRouting & AssetRouting & SettingsRouting)) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleScreenLabel.text = "Dashboard"
        balanceLabel.text = "Balance"
        transactionsLabel.text = "Transactions"

        bindBalanceLabel()
        addAndBindAssetBarChart()
        addAndBindTransactionsList()
        configureUserImage()
        addCoreDataObservers()
        fetch()
    }
 
    func addCoreDataObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(_:)),
                                               name: Notification.Name.NSManagedObjectContextDidSave,
                                               object: nil)
    }
    
    @objc func contextDidSave(_ notification: Notification) {
        fetch()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func fetch() {
        viewModel.getAssets()
        viewModel.getTransactions()
    }
    
    @objc func routeToSettings() {
        coordinator.routeToSettings()
    }
    
    private func configureUserImage() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(routeToSettings))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(tap)
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
        })
        
        
        viewModel.onTransactionsFetchedDo = { transactions in
            transactionsViewModel.updateTransactions(transactions: Array((transactions ?? []).prefix(6)))
        }
    }
}
