//
//  DetailsView.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 18/04/2024.
//

import SwiftUI

// El JSON proporcionado como una cadena
let json = """
{
    "interface":"V1_NFT",
    "id":"HihgSW5JwQ8HkmorGpVbLZtHiiAu7p9L2GNFFawVZhpz",
    "content":{
        "$schema":"https://schema.metaplex.com/nft1.0.json",
        "json_uri":"https://asolgift.com/self6.json",
        "files":[
            {
                "uri":"https://madlads.s3.us-west-2.amazonaws.com/images/3844.png",
                "cdn_uri":"https://cdn.helius-rpc.com/cdn-cgi/image//https://madlads.s3.us-west-2.amazonaws.com/images/3844.png",
                "mime":"image/png"
            }
        ],
        "metadata":{
            "attributes":[
                {
                    "value":"Visit aSOLGift.com to claim this NFT for FREE",
                    "trait_type":"DESCRIPTION"
                },
                {
                    "value":"Verified",
                    "trait_type":"STATUS"
                },
                {
                    "value":"26 minutes",
                    "trait_type":"TIME LEFT"
                }
            ],
            "description":"Fock it.",
            "name":"Mad Lads #3844",
            "symbol":"",
            "token_standard":"NonFungible"
        },
        "links":{
            "image":"https://madlads.s3.us-west-2.amazonaws.com/images/3844.png",
            "external_url":""
        }
    },
    "authorities":[
        {
            "address":"368M5aQBn4PFnFytiHpFxy69weZNcMAh8hy2CCZoB85P",
            "scopes":[
                "full"
            ]
        }
    ],
    "compression":{
        "eligible":false,
        "compressed":true,
        "data_hash":"GNe1cSBWhLpPBf8xRH88A1DhJ7M3qd3iXugM5pdwyjcB",
        "creator_hash":"FwH626jJXcmLwWx6S8zLkkSg2zsuikiH8N7wG3z7UhNF",
        "asset_hash":"BAP2XXn6pT8SoB9dzM7mZeQ5NQRPdnFGsrVZdcEA4ffk",
        "tree":"HVGMVJ7DyfXLU2H5AJSHvX2HkFrRrHQAoXAHfYUmicYr",
        "seq":139026,
        "leaf_id":138887
    },
    "royalty":{
        "royalty_model":"creators",
        "percent":0.05,
        "basis_points":500,
        "primary_sale_happened":false,
        "locked":false
    },
    "creators":[
        {
            "address":"GRtV4BCZEW1Eo1DHvscWaW5tmp7TuNmZwc5LXHow32Hz",
            "share":100,
            "verified":false
        }
    ],
    "ownership":{
        "owner":"AVUCZyuT35YSuj4RH7fwiyPu82Djn2Hfg7y2ND2XcnZH",
        "frozen":false,
        "delegated":false,
        "delegate":null,
        "ownership_model":"single"
    },
    "mutable":true,
    "burnt":false
}
"""


struct NFT: Identifiable {
    var id: String
    var name: String
    var description: String
    var imageUrl: URL
    var address: String
    var royaltyFee: Double
    var attributes: [AssetAttribute]
    
    init(from assetItem: AssetItem) {
        self.id = assetItem.id ?? ""
        
        
        self.name = assetItem.content?.metadata?.name ?? ""
        self.description = assetItem.content?.metadata?.description ?? ""
        
        // Inicializar la URL de la imagen del NFT
        if let imageUrlString = assetItem.content?.links?.image, let url = URL(string: imageUrlString) {
            self.imageUrl = url
        } else {
            self.imageUrl = URL(string: "https://assets.coingecko.com/coins/images/4128/standard/solana.png?1696504756")!
        }

        self.address = assetItem.id ?? ""
        
        
        // Inicializar la tarifa de regalías del creador
        if let royalty = assetItem.royalty {
            self.royaltyFee = royalty.percent ?? 0.0
        } else {
            self.royaltyFee = 0.0
        }
        
        self.attributes = assetItem.content?.metadata?.attributes ?? []
    }
}

struct NFTDetailView: View {
    var nft: NFT
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                VStack {
                    AsyncImage(url: nft.imageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350, height: 350)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding()
                    } placeholder: {
                        ProgressView()
                            .frame(width: 350, height: 350)
                            .background(Color.backgroundDarkGray)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity)
                
                HStack {
                    Text("Description")
                        .padding(.leading, 20)
                        .foregroundStyle(Color.textLightGray)
                    Spacer()
                }
                HStack {
                    Text(nft.description)
                        .font(.body)
                        .padding()
                    Spacer()
                }
                .background(Color.backgroundDarkGray)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Attributes")
                            .padding(.leading, 2)
                            .foregroundStyle(Color.textLightGray)
                        Spacer()
                    }
                    VStack {
                        ForEach(0..<nft.attributes.count, id: \.self) { index in
                            let attribute = nft.attributes[index]
                            let isLast = index == nft.attributes.count - 1

                            HStack {
                                VStack {
                                    Text("\(attribute.traitType?.capitalized ?? "")")
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                                Spacer()
                                VStack {
                                    Text("\(attribute.value?.stringValue ?? "")")
                                    Spacer()
                                }
                            }
                            
                            if !isLast {
                                Divider()
                                    .background(Color.listSeparatorDarkGray)
                                    .padding(.vertical, 5)
                            } else {
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 15)
                    .background(Color.backgroundDarkGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                }
                .padding(.bottom, 20)
                .padding(.horizontal)
                
                HStack {
                    Text("Details")
                        .padding(.leading, 20)
                        .foregroundStyle(Color.textLightGray)
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Address")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(nft.address.shortSignature)
                        
                    }
                    
                    Divider()
                        .background(Color.listSeparatorDarkGray)
                    HStack {
                        Text("Creator Royalty Fee")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(nft.royaltyFee * 100, specifier: "%.2f")%")
                    }
                    .padding(.bottom, 5)
                    Divider()
                        .background(Color.listSeparatorDarkGray)
                    HStack {
                        Text("View on Magic Eden")
                            .fontWeight(.semibold)
                            .underline()
                        Spacer()
                    }
                    .onTapGesture {
                        if true {
                            if let url = URL(string: "https://solscan.io/token/\(nft.address)"), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                        } else {
                            if let url = URL(string: "https://magiceden.io/item-details/\(nft.address)"), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.backgroundDarkGray)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                
                
            }
        }
        .scrollIndicators(.hidden)
        .foregroundStyle(.white)
        .background(.black)
        .navigationBarTitle(nft.name, displayMode: .inline)
        
    }
}

struct DetailsView: View {
    let nft: NFT

    var body: some View {
        NFTDetailView(nft: nft)
    }
}

#Preview {
    func convertJsonToAssetItem(json: String) -> AssetItem? {
        let jsonData = Data(json.utf8)
        let decoder = JSONDecoder()
        
        do {
            let assetItem = try decoder.decode(AssetItem.self, from: jsonData)
            return assetItem
        } catch {
            print("Error al decodificar JSON: \(error)")
            return nil
        }
    }
    
    func createDummyNFT(json: String) -> NFT? {
        // Convertir JSON a AssetItem
        if let assetItem = convertJsonToAssetItem(json: json) {
            // Crear una instancia de NFT a partir de AssetItem
            let nft = NFT(from: assetItem)
            return nft
        } else {
            print("Error al convertir JSON a AssetItem.")
            return nil
        }
    }
    
    return DetailsView(nft: createDummyNFT(json: json)!)
}


