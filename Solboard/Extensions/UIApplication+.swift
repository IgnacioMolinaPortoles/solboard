//
//  UIApplication+.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 28/03/2024.
//

import UIKit
import Foundation

protocol UIApplicationURLRouterProtocol {
    func _canOpenURL(_ url: URL) -> Bool
    func _open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler: ((Bool) -> Void)?)
}

extension UIApplication: UIApplicationURLRouterProtocol {
    func _canOpenURL(_ url: URL) -> Bool {
        return UIApplication.shared.canOpenURL(url)
    }
    
    func _open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:], completionHandler: ((Bool) -> Void)? = nil) {
        open(url, options: options, completionHandler: completionHandler)
    }
}

extension UIApplication {
    static var appDelegate: AppDelegate? {
        shared.delegate as? AppDelegate
    }
    
    static var sceneDelegate: SceneDelegate? {
        shared.connectedScenes.first?.delegate as? SceneDelegate
    }
}
