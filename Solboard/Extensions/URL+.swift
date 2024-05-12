//
//  URL+.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 12/05/2024.
//

import Foundation

extension URL {
    func isSolanaURL() -> Bool {
        self.absoluteString == Constants.solanaImageURL
    }
}
