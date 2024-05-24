//
//  AlertManager.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 10/04/2024.
//

import Foundation
import UIKit

protocol AlertManagerProtocol {
    func showAlert(_ title: String,_ message: String?, actions: [UIAlertAction]?, viewController: UIViewController?)
}
class AlertManager: AlertManagerProtocol {
    
    func showAlert(_ title: String, _ message: String?, actions: [UIAlertAction]?, viewController: UIViewController?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let actions, actions.count > 0 {
            for action in actions {
                alertController.addAction(action)
            }
        } else {
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        }
        
        guard let viewController else {
            UIApplication.topViewController()?.present(alertController, animated: true)
            return
        }
        
        viewController.present(alertController, animated: true)
    }
}
