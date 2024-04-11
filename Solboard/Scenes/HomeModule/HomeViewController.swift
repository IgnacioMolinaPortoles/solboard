//
//  HomeViewController.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 26/03/2024.
//

import UIKit
import SwiftUI



class HomeViewController: UIViewController {

    @IBOutlet weak var titleScreenLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var transactionsLabel: UILabel!
    @IBOutlet weak var transactionsView: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleScreenLabel.text = "Dashboard"
        balanceLabel.text = "Balance"
        transactionsLabel.text = "Transactions"
        
        balanceView.addAssetBarChart(tokensData: tokens,
                                     onAssetDistributionTapDo: {
            print("Si")
        })
        
        
        transactionsView.addTransactionList(transaction: mockedTransactions,
                                            onTransactionTapDo: {
            print("No")
        }, tableTitle: "TYPE")
    }
}
