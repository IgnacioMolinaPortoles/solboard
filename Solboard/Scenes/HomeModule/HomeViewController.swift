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
    
    var onAssetsFetchedDo: (([TokenViewModel]?, Double) -> Void)?
    
    private var response: AssetByOwnerResponse?
    private var assets: [AssetViewModel] = []
    
    init(assetService: AssetsServiceProtocol) {
        self.assetService = assetService
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
            
            self?.onAssetsFetchedDo!(tokenViewModel, totalBalance)
        }
    }
}

final class HomeViewController: UIViewController {

    @IBOutlet weak var titleScreenLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var transactionsLabel: UILabel!
    @IBOutlet weak var transactionsView: UIView!
    
    private let viewModel = HomeViewModel(assetService: AssetsService())
    
//    init(viewModel: HomeViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleScreenLabel.text = "Dashboard"
        balanceLabel.text = "Balance"
        transactionsLabel.text = "Transactions"
        let barchartViewModel = self.balanceView.addAssetBarChart(tokensData: [],
                                     onAssetDistributionTapDo: {
            
            print("assets")
        })
        
        viewModel.onAssetsFetchedDo = { (assets, totalBalance) in
            barchartViewModel.updateTokens(tokens: assets!)
            self.balanceLabel.text = "Balance: $\(String(format: "%.2f", totalBalance))"
        }
        
        viewModel.getAssets()
        
        TransactionsService(client: URLSession.shared).getSignatures() { transactions in
            self.transactionsView.addTransactionList(transaction: transactions,
                                                onTransactionTapDo: { txh in
                print("No \(txh)")
                guard let url = URL(string: "https://solscan.io/tx/"+txh) else { return }
                UIApplication.shared.open(url)
            }, tableTitle: "TX")
        }
        
        
        
    }
}
