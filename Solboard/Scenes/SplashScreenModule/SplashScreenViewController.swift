//
//  SplashScreenViewController.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 26/03/2024.
//

import UIKit

class SplashScreenViewController: UIViewController {
    var coordinator: (Coordinator & ImportingWallet)?
        
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func onImportWalletButtonTapDo(_ sender: Any) {
        coordinator?.importWallet()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
