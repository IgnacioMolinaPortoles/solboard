//
//  TransactionOverviewItemView.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 08/05/2024.
//

import SwiftUI

struct TransactionOverviewItem: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
        }
    }
}
