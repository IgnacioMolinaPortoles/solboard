//
//  Int+.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 06/05/2024.
//

import Foundation

extension Int {
    func parseFee() -> String {
        let solValue = Double(self) / Constants.lamports
        return "\(solValue.allDecimals()) SOL"
    }
}

extension Double {
    func allDecimals(maximumFractionDigits: Int = 16) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = maximumFractionDigits
        return formatter.string(from: NSNumber(value: self)) ?? "0.00"
    }
}
