//
//  String+.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 08/05/2024.
//

import Foundation

extension String {
    var shortSignature: String {
        self.count > 0 ?
        self.prefix(6) + "..." + self.suffix(6) :
        ""
    }
    
    var includeAddSymbol: String {
        if !self.contains("- ") {
            return "+ \(self)"
        }
        return self
    }
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}
