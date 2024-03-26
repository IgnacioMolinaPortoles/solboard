//
//  ImportWalletViewController.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 26/03/2024.
//

import UIKit

class ImportWalletViewController: UIViewController {
    var coordinator: (Coordinator & HomeBuilding)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onContinueButtonTapDo(_ sender: Any) {
        coordinator?.buildHome()
    }
}
