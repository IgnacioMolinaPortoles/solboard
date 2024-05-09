//
//  TransactionViewModel.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 14/04/2024.
//

import Foundation

struct TransactionViewModel: Identifiable {
    var id: String = UUID().uuidString
    
    var signatureHash: String
    var unixDate: Int
}
