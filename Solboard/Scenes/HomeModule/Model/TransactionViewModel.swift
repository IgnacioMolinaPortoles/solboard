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
    
    var shortSignature: String {
        signatureHash.prefix(13) + "..."
    }
    
    var presentableDate: String {
        DateParser.shared.getParsedDate(TimeInterval(self.unixDate))
    }
}

extension String {
    var shortSignature: String {
        self.count > 0 ?
        self.prefix(6) + "..." + self.suffix(6) :
        ""
    }
}
