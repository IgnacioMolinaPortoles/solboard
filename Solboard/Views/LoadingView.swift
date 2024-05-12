//
//  LoadingView.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 11/05/2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
            .background(Color.backgroundDarkGray1C)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    LoadingView()
}
