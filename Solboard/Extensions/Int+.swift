//
//  Int+.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 06/05/2024.
//

import Foundation

extension Double {
    func allDecimals() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 16
        return formatter.string(from: NSNumber(value: self)) ?? "0.00"
    }
}
