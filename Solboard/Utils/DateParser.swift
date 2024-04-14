//
//  DateParser.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 14/04/2024.
//

import Foundation

final class DateParser {
    static let shared = DateParser()
    
    private init() {}
    
    func getParsedDate(_ unixDate: TimeInterval) -> String {
        if hoursSince(fechaUnix: unixDate) > 23 {
            return unixTimestampToDate(unixTimestamp: unixDate)
        } else {
            return minutesSince(fechaUnix: unixDate)
        }
    }
    
    private func unixTimestampToDate(unixTimestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    private func hoursSince(fechaUnix: TimeInterval) -> Int {
        let ahora = Date()
        let fecha = Date(timeIntervalSince1970: fechaUnix)
        let intervalo = ahora.timeIntervalSince(fecha)
        
        let horas = Int(intervalo / 3600)
        
        return horas
    }
    
    private func minutesSince(fechaUnix: TimeInterval) -> String {
        let ahora = Date()
        let fecha = Date(timeIntervalSince1970: fechaUnix)
        let intervalo = ahora.timeIntervalSince(fecha)
        
        if intervalo < 60 {
            // Menos de un minuto
            return ">1 min"
        } else if intervalo < 3600 {
            // Entre 1 minuto y 59 minutos
            let minutos = Int(intervalo / 60)
            return "\(minutos) minutos"
        } else {
            // Más de 60 minutos
            let horas = Int(intervalo / 3600)
            return "\(horas) horas"
        }
    }
}
