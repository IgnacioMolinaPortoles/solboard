//
//  Colors+.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 11/04/2024.
//

import Foundation
import UIKit
import SwiftUI

extension UIColor {
    convenience init(hex:String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init(.gray)
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static var backgroundDarkGray1C: UIColor {
        UIColor(hex: "1C1C1C")
    }
    
    static var backgroundDarkGray2D: UIColor {
        UIColor(hex: "#2d2d2e")
    }
    
    static var listSeparatorDarkGray: UIColor {
        UIColor(hex: "2B2A2C")
    }
    
    static var textLightGray: UIColor {
        UIColor(hex: "9F9EA2")
    }
}

extension Color {
    init(hex:String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init(.gray)
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0
        )
    }
    
    static var backgroundDarkGray1C: Color {
        Color(hex: "1C1C1C")
    }
    
    static var backgroundDarkGray2D: Color {
        Color(hex: "#2d2d2e")
    }
    
    static var backgroundDarkGray5D: Color {
        Color(hex: "#5d5c61")
    }
    
    static var listSeparatorDarkGray: Color {
        Color(hex: "2B2A2C")
    }
    
    static var textLightGray: Color {
        Color(hex: "9F9EA2")
    }
    
    static var _green: Color {
        Color(hex: "#35c658")
    }
    
    static var _red: Color {
        Color(hex: "#ff3d2e")
    }
}
