//
//  UIView+.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 11/04/2024.
//

import Foundation
import UIKit

extension UIView {
    func attach(toView view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension UIViewController {
    func copyToClipboard(_ text: String?) {
        let alertManager = AlertManager()
        
        guard let text else {
            alertManager.showAlert("An error ocurred",
                                     "Sorry, we cannot copy the address to the clipboard right now",
                                     actions: [UIAlertAction(title: "Ok", style: .default)],
                                     viewController: self)
            return
        }
        UIPasteboard.general.string = text
        alertManager.showAlert("Copied to clipboard",
                                 nil,
                                 actions: [UIAlertAction(title: "Done", style: .default)],
                                 viewController: self)
    }
}
