//
//  View+.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 11/05/2024.
//

import Foundation
import SwiftUI

struct DynamicTextSelection: ViewModifier {
    var allowsSelection: Bool

    func body(content: Content) -> some View {
        if allowsSelection {
            content.textSelection(.enabled)
        } else {
            content.textSelection(.disabled)
        }
    }
}

extension View {
    func dynamicTextSelection(_ allowsSelection: Bool) -> some View {
        self.modifier(DynamicTextSelection(allowsSelection: allowsSelection))
    }
}
