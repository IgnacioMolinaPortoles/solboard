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
