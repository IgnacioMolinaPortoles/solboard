//
//  AssetsView.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 14/04/2024.
//

import SwiftUI
import Kingfisher

let assetsArray = [
    AssetItemViewModel(address: "Czfq3xZZDmsdGdUyrNLtRhGc47cXcZtLG4crryfu44zE",
                   pricePerToken: 12,
                   balance: 0.0000023210,
                   name: "MYTHYS",
                   symbol:"MYTCHYS",
                   tokenType: .fungible,
                   metadata: nil,
                       image: Constants.solanaImageURL),
    AssetItemViewModel(address: "H2m6pFixfGiQcA7KjveiqAZTBJHysGToY5cJFewtkky8",
                   pricePerToken: 0,
                   balance: 1,
                   name: "CoolXCats",
                   symbol:"CDCC",
                   tokenType: .nonFungible,
                   metadata: nil,
                   image: "https://madlads.s3.us-west-2.amazonaws.com/images/3844.png")
]

class AssetsListViewModel: ObservableObject {
    @Published var tokens: [AssetItemViewModel]
    @Published var assetSelected = 0
    @Published var searchText = ""
    
    init(tokens: [AssetItemViewModel]) {
        self.tokens = tokens
    }
    
    func updateTokens(tokens: [AssetItemViewModel]) {
        self.tokens = tokens
    }

    func selectAsset(_ asset: AssetItemViewModel) {
        asset.onAssetDetailTap?()
    }

    var filteredTokens: [AssetItemViewModel] {
        let filteredBySegment = filterTokensBySegment()
        if searchText.isEmpty {
            return filteredBySegment
        } else {
            return filterTokensBySearch(filteredBySegment)
        }
    }

    private func filterTokensBySegment() -> [AssetItemViewModel] {
        switch assetSelected {
        case 0: // Tokens
            return tokens.filter { $0.tokenType == .fungible }
        case 1: // NFTs
            return tokens.filter { $0.tokenType == .nonFungible }
        default: // All
            return tokens
        }
    }

    private func filterTokensBySearch(_ tokens: [AssetItemViewModel]) -> [AssetItemViewModel] {
        return tokens.filter { asset in
            asset.symbol?.localizedCaseInsensitiveContains(searchText) ?? false 
            ||
            asset.name?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
}


struct AssetsListView: View {
    @ObservedObject var viewModel: AssetsListViewModel
    
    init(viewModel: AssetsListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $viewModel.assetSelected) {
                    Text("Tokens").tag(0)
                    Text("NFTs").tag(1)
                    Text("All").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 15)
                .padding(.bottom, 4)
                
                List {
                    ForEach(viewModel.filteredTokens, id: \.id) { asset in
                        HStack {
                            
                            if asset.image ?? "" == Constants.solanaImageURL {
                                Image(.solana)
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            } else {
                                KFImage(URL(string: asset.image ?? ""))
                                    .placeholder {
                                        ProgressView()
                                            .frame(maxWidth: 25, maxHeight: 25)
                                    }
                                    .fade(duration: 0.25)
                                    .resizable()
                                    .frame(maxWidth: 25, maxHeight: 25)
                            }
                            Text(asset.tokenType == .fungible ? "\(asset.symbol ?? "")" : "\(asset.name ?? "")")
                            Spacer()
                            
                            if asset.tokenType == .fungible {
                                let totalPrice = asset.balance ?? 0
                                let specifier = String(format: "%.4f", totalPrice).prefix(4) == "0.00" ? "%.8f" : "%.2f"

                                Text("\(totalPrice, specifier: specifier)")
                                    .foregroundStyle(Color.textLightGray)
                            }
                            Image(systemName: "chevron.right")
                        }
                        .onTapGesture {
                            viewModel.selectAsset(asset)
                        }
                    }
                    .listRowBackground(Color.backgroundDarkGray1C)
                }
                .padding(.top, -30)
                .padding(.leading, -3)
                .padding(.trailing, -5)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Spacer()
            }
            .transaction { transaction in
                transaction.animation = .linear(duration: 0.25)
            }
        }
        .preferredColorScheme(.dark)
        .searchable(text: $viewModel.searchText)
        .navigationTitle("Assets")
    }
}

#Preview {
    AssetsListView(viewModel: AssetsListViewModel(tokens: assetsArray))
}
