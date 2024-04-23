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
    
    var formatedNumber: String {
        // Crear un NumberFormatter para formatear el número con la precisión de decimales deseada
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 16

        // Convertir el número a una cadena formateada
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: self.doubleValue)) else {
            return "\(self)"
        }

        // Verificar si la parte fraccionaria es cero
        let decimalSeparator = numberFormatter.decimalSeparator ?? "."
        if let decimalIndex = formattedNumber.firstIndex(of: Character(decimalSeparator)) {
            // Obtener la parte decimal del número
            let decimalPart = formattedNumber[formattedNumber.index(after: decimalIndex)...]
            // Verificar si la parte decimal es cero
            if Double(decimalPart) == 0.0 {
                // Si la parte decimal es cero, devolver solo la parte entera
                return formattedNumber[..<decimalIndex].description
            }
        }

        // Si los decimales existen y no son cero, devolver el número formateado
        return formattedNumber
    }
}

extension Double {
    var formatedNumber: String {
        // Crear un NumberFormatter para formatear el número con la precisión de decimales deseada
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 16

        // Convertir el número a una cadena formateada
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: self)) else {
            return "\(self)"
        }

        // Verificar si la parte fraccionaria es cero
        let decimalSeparator = numberFormatter.decimalSeparator ?? "."
        if let decimalIndex = formattedNumber.firstIndex(of: Character(decimalSeparator)) {
            // Obtener la parte decimal del número
            let decimalPart = formattedNumber[formattedNumber.index(after: decimalIndex)...]
            // Verificar si la parte decimal es cero
            if Double(decimalPart) == 0.0 {
                // Si la parte decimal es cero, devolver solo la parte entera
                return formattedNumber[..<decimalIndex].description
            }
        }

        // Si los decimales existen y no son cero, devolver el número formateado
        return formattedNumber
    }
}
