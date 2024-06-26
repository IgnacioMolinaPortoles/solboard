//
//  TransactionOverviewItemView.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 08/05/2024.
//

import SwiftUI

struct TransactionOverviewItem: View, Identifiable {
    var id: UUID
    
    let title: String
    let valueUnderlined: Bool
    let value: String
    let valueColor: Color
    let onTapDo: (() -> Void)?
    
    init(title: String, 
         value: String,
         valueColor: Color = .white,
         valueUnderlined: Bool = false,
         onTapDo: (() -> Void)? = nil) {
        self.id = UUID()
        self.title = title
        self.value = value
        self.onTapDo = onTapDo
        self.valueColor = valueColor
        self.valueUnderlined = valueUnderlined
    }
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .fontWeight(valueUnderlined ? .semibold : .regular)
                .underline(valueUnderlined)
                .foregroundStyle(self.valueColor)
        }
        .onTapGesture(perform: {
            guard let onTapDo else {
                return
            }
            
            onTapDo()
        })
    }
}
