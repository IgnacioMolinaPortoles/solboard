//
//  UIApplication+.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 28/03/2024.
//

import UIKit
import Foundation

extension UIApplication {
    static var appDelegate: AppDelegate? {
        shared.delegate as? AppDelegate
    }
    
    static var sceneDelegate: SceneDelegate? {
        shared.connectedScenes.first?.delegate as? SceneDelegate
    }
}
