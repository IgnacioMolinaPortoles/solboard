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
    
    func getFetchedAssets() -> [AssetItem] {
        self.response?.result?.items ?? []
    }
    
    func getTransactions() {
        transactionsService.getSignatures("G3ZTjo4ak5cgsVdyCPNu2QqoWA7kk18aiECEqQZp1RNk") { [weak self] transactions in
            self?.onTransactionsFetchedDo!(transactions)
        }
    }

    func getAssets() {
        self.assets = []
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            self?.assetService.getAddressAssets("G3ZTjo4ak5cgsVdyCPNu2QqoWA7kk18aiECEqQZp1RNk") { response in
                self?.response = response
                self?.assets.append(contentsOf: AssetsMapper.map(response: response))
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            self?.assetService.getSolanaPrice() { price in
                self?.assetService.getBalance("G3ZTjo4ak5cgsVdyCPNu2QqoWA7kk18aiECEqQZp1RNk") { solBalance in
                    self?.assets.append(AssetViewModel(address: "",
                                                       pricePerToken: price,
                                                       balance: Decimal(solBalance),
                                                       name: "SOL",
                                                       symbol: "SOL",
                                                       tokenType: .fungible,
                                                       metadata: nil,
                                                       image: "https://assets.coingecko.com/coins/images/4128/standard/solana.png?1696504756"))
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
            
            let assetsVMArray = self.viewModel.getFetchedAssets().map { assetItem in
                var assetVM = AssetViewModel(from: assetItem)
                assetVM.onAssetDetailTap = selection(item: assetItem)
                return assetVM
            }
                
            func selection(item: AssetItem) -> () -> Void {
                {
                    let vc = UIHostingController(rootView: DetailsView(nft: NFT(from: item))) 
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }

            let vm = AssetsListViewModel(tokens: assetsVMArray)
            let vc = UIHostingController(rootView: AssetsListView(viewModel: vm))
            self.navigationController?.pushViewController(vc,
                                                          animated: true)
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
