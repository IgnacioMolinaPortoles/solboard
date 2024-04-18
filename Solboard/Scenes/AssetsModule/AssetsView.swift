//
//  AssetsView.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 14/04/2024.
//

import SwiftUI

let assetsArray = [
    AssetViewModel(assetAddress: "Czfq3xZZDmsdGdUyrNLtRhGc47cXcZtLG4crryfu44zE",
                   pricePerToken: 12,
                   balance: 0,
                   name: "MYTHYS",
                   symbol:"MYTCHYS",
                   tokenType: .fungible,
                   metadata: "",
                   image: "https://bafkreie3gbnqk4odanmu76oebzmqxzd564hxu5csws6liojjjnlgybbx3y.ipfs.nftstorage.link/"),
    AssetViewModel(assetAddress: "H2m6pFixfGiQcA7KjveiqAZTBJHysGToY5cJFewtkky8",
                   pricePerToken: 0,
                   balance: 1,
                   name: "CoolXCats",
                   symbol:"CDCC",
                   tokenType: .nonFungible,
                   metadata: "",
                   image: "https://madlads.s3.us-west-2.amazonaws.com/images/3844.png"),
    AssetViewModel(assetAddress: "Czfq3xZZDmsdGdUyrNLtRhGc47cXcZtLG4crryfu44zE",
                   pricePerToken: 12,
                   balance: 0,
                   name: "MYTDHYS",
                   symbol:"MYTHYS",
                   tokenType: .fungible,
                   metadata: "",
                   image: "https://bafkreie3gbnqk4odanmu76oebzmqxzd564hxu5csws6liojjjnlgybbx3y.ipfs.nftstorage.link/"),
    AssetViewModel(assetAddress: "H2m6pFixfGiQcA7KjveiqAZTBJHysGToY5cJFewtkky8",
                   pricePerToken: 0,
                   balance: 1,
                   name: "CoolCats",
                   symbol:"CC",
                   tokenType: .nonFungible,
                   metadata: "",
                   image: "https://madlads.s3.us-west-2.amazonaws.com/images/3844.png")
]

class AssetsViewViewModel: ObservableObject {
    @Published var tokens: [AssetViewModel]
    @Published var assetSelected = 0
    @Published var searchText = ""
    @Published var lastAssetTapped = AssetViewModel(tokenType: .fungible)
    @Published var isSheetPresented = false
    
    init(tokens: [AssetViewModel]) {
        self.tokens = tokens
    }
    func selectAsset(_ asset: AssetViewModel) {
        lastAssetTapped = asset
        isSheetPresented = true
    }
    
    func dismissSheet() {
        isSheetPresented = false
    }
    
    func updateTokens(tokens: [AssetViewModel]) {
        self.tokens = tokens
    }
    
    var filteredTokens: [AssetViewModel] {
        if searchText.isEmpty {
            return filteredBySegment()
        } else {
            return filteredBySegment().filter { asset in
                asset.symbol?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
    }
    
    private func filteredBySegment() -> [AssetViewModel] {
        switch assetSelected {
        case 0: // Tokens
            return tokens.filter { $0.tokenType == .fungible }
        case 1: // NFTs
            return tokens.filter { $0.tokenType == .nonFungible }
        default: // All
            return tokens
        }
    }
}

struct AssetsView: View {
    @ObservedObject private var viewModel: AssetsViewViewModel
    
    @State private var presented = false
    
    init(viewModel: AssetsViewViewModel) {
        self.viewModel = viewModel
    }
    
    func itemTapped(_ asset: AssetViewModel) {
        viewModel.selectAsset(asset)
        presented.toggle()
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
                    
                    
                    ForEach(viewModel.filteredTokens, id: \.id) { asset in // Usamos filteredTokens
                        let text = asset.tokenType == .fungible ? "\(asset.pricePerToken!)" : "\("NFT")"
                        HStack {
                            AsyncImage(url: URL(string: asset.image ?? ""),
                                       content: { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 25, maxHeight: 25)
                            },
                                       placeholder: {
                                ProgressView()
                            })
                            .frame(width: 25, height: 25)
                            
                            Text("\(asset.symbol ?? "")")
                                .foregroundStyle(.white)
                                .onTapGesture {
                                    itemTapped(asset)
                                }
                            Spacer()
                            Text("\(text)")
                                .foregroundStyle(Color.textLightGray)
                            Image(systemName: "chevron.right")
                        }
                    }
                    .listRowBackground(Color.backgroundDarkGray)
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
        .sheet(isPresented: $viewModel.isSheetPresented) {
            let asset = $viewModel.lastAssetTapped
            let address = asset.assetAddress.wrappedValue!
            var url = asset.tokenType.wrappedValue == .fungible ?
            "https://solscan.io/token/\(address)/"
            :
            "https://magiceden.io/item-details/\(address)"
            
            WebView(url: URL(string: url)!)
        }
        
    }
}

#Preview {
    AssetsView(viewModel: AssetsViewViewModel(tokens: assetsArray))
}
