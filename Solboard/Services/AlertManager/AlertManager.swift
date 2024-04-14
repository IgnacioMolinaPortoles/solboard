//
//  AlertManager.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 10/04/2024.
//

import Foundation
import UIKit

protocol AlertManagerProtocol {
    func showAlert(_ title: String,_ message: String, actions: [UIAlertAction]?, viewController: UIViewController)
}
class AlertManager: AlertManagerProtocol {
    
    func showAlert(_ title: String, _ message: String, actions: [UIAlertAction]?, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if (actions?.isEmpty ?? false) {
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        } else {
            for action in actions ?? [] {
                alertController.addAction(action)
            }
        }
        
        viewController.present(alertController, animated: true)
    }
}
