//
//  Decimal+.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 13/04/2024.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
}
