//
//  HomeViewController.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 26/03/2024.
//

import UIKit
import SwiftUI

final class HomeViewModel {
    private let assetService: AssetsServiceProtocol
    private let transactionsService: TransactionsServiceProtocol

    
    var onAssetsFetchedDo: (([TokenViewModel]?) -> Void)?
    var onBalanceFetchedDo: ((Double) -> Void)?
    var onTransactionsFetchedDo: (([TransactionViewModel]?) -> Void)?
    
    private var response: AssetByOwnerResponse?
    private var assets: [AssetViewModel] = []
    
    init(assetService: AssetsServiceProtocol,
         transactionsService: TransactionsServiceProtocol) {
        self.assetService = assetService
        self.transactionsService = transactionsService
    }
    
    func getTransactions() {
        transactionsService.getSignatures("AVUCZyuT35YSuj4RH7fwiyPu82Djn2Hfg7y2ND2XcnZH") { [weak self] transactions in
            self?.onTransactionsFetchedDo!(transactions)
        }
    }

    func getAssets() {
        self.assets = []
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            self?.assetService.getAddressAssets("AVUCZyuT35YSuj4RH7fwiyPu82Djn2Hfg7y2ND2XcnZH") { response in
                self?.response = response
                self?.assets.append(contentsOf: AssetsMapper.map(response: response))
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            self?.assetService.getSolanaPrice() { price in
                self?.assetService.getBalance("AVUCZyuT35YSuj4RH7fwiyPu82Djn2Hfg7y2ND2XcnZH") { solBalance in
                    self?.assets.append(AssetViewModel(assetAddress: "",
                                                       pricePerToken: price,
                                                       balance: Decimal(solBalance),
                                                       name: "SOL",
                                                       tokenType: .fungible,
                                                       metadata: ""))
                    dispatchGroup.leave()
                }
            }
        }
        
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            let tokenViewModel = self?.assets.toTokenViewModel()
            let totalBalance = self?.assets.reduce(0.0) { $0 + (Double(($1.balance?.doubleValue ?? 0.0)) * ($1.pricePerToken ?? 0.0)) } ?? 0.0
            
            self?.onBalanceFetchedDo!(totalBalance)
            self?.onAssetsFetchedDo!(tokenViewModel)
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
    private let coordinator: TransactionRouting?
    
    init(viewModel: HomeViewModel = HomeViewModel(assetService: AssetsService(), 
                                                  transactionsService: TransactionsService()),
         coordinator: TransactionRouting) {
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
                                                                  onAssetTapDo: { tokenType in
            
            print("assets", tokenType.rawValue)
        })
        
        viewModel.onAssetsFetchedDo = { (assets) in
            barchartViewModel.updateTokens(tokens: assets ?? [])
        }
    }
    
    private func addAndBindTransactionsList() {
        let transactionsViewModel = self.transactionsView.addTransactionList(transactions: [],
                                            onTransactionTapDo: { [weak self] tx in
            self?.coordinator?.routeToTransactionDetail(tx: tx)
        }, tableTitle: "Signature")
        
        
        viewModel.onTransactionsFetchedDo = { transactions in
            transactionsViewModel.updateTransactions(transactions: transactions ?? [])
        }
    }
}
