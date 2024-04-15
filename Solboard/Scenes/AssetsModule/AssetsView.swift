//
//  AssetsView.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 14/04/2024.
//

import SwiftUI

struct AssetsView: View {
    @State private var assetSelected = 0
    @State private var searchText = ""

    var body: some View {
        
        NavigationStack {
            VStack {
                Picker("", selection: $assetSelected) {
                    Text("Tokens").tag(0)
                    Text("NFTs").tag(1)
                    Text("All").tag(2)
                }
                .pickerStyle(.segmented)

                Text("Searching for \(searchText)")
                Spacer()
            }
            .transaction { transaction in
                transaction.animation = .linear(duration: 0.25)
            }
//            .navigationTitle("Assets")
            
        }
        .searchable(text: $searchText)

    }
}

#Preview {
    AssetsView()
}
