//
//  GenericEmptyView.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 05/06/2024.
//

import SwiftUI

struct GenericEmptyView: View {
    var body: some View {
        HStack {
            Text("We could not retrieve any data")
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
        .background(Color.backgroundDarkGray1C)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    GenericEmptyView()
}
