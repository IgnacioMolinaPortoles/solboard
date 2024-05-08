//
//  DetailsView.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 18/04/2024.
//

import SwiftUI

let tokenJson = """
{
        "interface": "FungibleToken",
        "id": "AB1e1rTGF8xSoYzXEwNWohuMHLCMrBoaSxT6AARmQksd",
        "content": {
          "$schema": "https://schema.metaplex.com/nft1.0.json",
          "json_uri": "https://gateway.irys.xyz/OcGcH3rSV1UqNiJsyx-RvmqDdLRnRut-N7Jz2Vim4gU",
          "files": [
            {
              "uri": "https://i.imgur.com/jmoirLq.jpeg",
              "cdn_uri": "https://cdn.helius-rpc.com/cdn-cgi/image//https://i.imgur.com/jmoirLq.jpeg",
              "mime": "image/jpeg"
            }
          ],
          "metadata": {
            "description": "Just Two Cats Talking About Life",
            "name": "TwoTalkingCats",
            "symbol": "TWOCAT",
            "token_standard": "Fungible"
          },
          "links": {
            "image": "https://i.imgur.com/jmoirLq.jpeg"
          }
        },
        "authorities": [
          {
            "address": "DkMe3tyhndt8d8FjYseszkGiyPaqTgLPvuwSzo5DQbY3",
            "scopes": [
              "full"
            ]
          }
        ],
        "compression": {
          "eligible": false,
          "compressed": false,
          "data_hash": "",
          "creator_hash": "",
          "asset_hash": "",
          "tree": "",
          "seq": 0,
          "leaf_id": 0
        },
        "grouping": [],
        "royalty": {
          "royalty_model": "creators",
          "target": null,
          "percent": 0,
          "basis_points": 0,
          "primary_sale_happened": false,
          "locked": false
        },
        "creators": [],
        "ownership": {
          "frozen": false,
          "delegated": false,
          "delegate": null,
          "ownership_model": "token",
          "owner": "AUXVBHMKvW6arSPPNbjSuz8y3f6HA2p8YCcKLr8HBGdh"
        },
        "supply": null,
        "mutable": true,
        "burnt": false,
        "token_info": {
          "symbol": "TWOCAT",
          "balance": 1666666600,
          "supply": 999982329407904,
          "decimals": 6,
          "token_program": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA",
          "associated_token_address": "8Y5di26DbFH3afDYqYYC7Lvp5ZrP4ihZ7ciXSoPs6KCZ",
          "price_info": {
            "price_per_token": 0.00337451,
            "total_price": 5.624183073431719,
            "currency": "USDC"
          }
        }
      }
"""

let nftJson = """
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

struct DetailView: View {
    var detailItem: DetailItemViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                VStack {
                    AsyncImage(url: detailItem.imageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
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
                    Text("Token info")
                        .padding(.leading, 20)
                        .foregroundStyle(Color.textLightGray)
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack {
                        Text("Balance")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(detailItem.formattedBalance)
                    }
                    
                    if detailItem.pricePerToken > 0 {
                        Divider()
                            .background(Color.listSeparatorDarkGray)
                        
                        HStack {
                            Text("Price per token")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(detailItem.formattedPricePerToken)
                        }
                        
                        Divider()
                            .background(Color.listSeparatorDarkGray)
                        
                        HStack {
                            Text("Total value")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(detailItem.formattedTotalValue)
                        }
                    }
                }
                .padding()
                .background(Color.backgroundDarkGray)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                if !detailItem.description.isEmpty {
                    HStack {
                        Text("Description")
                            .padding(.leading, 20)
                            .foregroundStyle(Color.textLightGray)
                        Spacer()
                    }
                    HStack {
                        Text(detailItem.description)
                            .font(.body)
                            .padding()
                        Spacer()
                    }
                    .background(Color.backgroundDarkGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                
                if detailItem.attributes.count > 0 {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Attributes")
                                .padding(.leading, 2)
                                .foregroundStyle(Color.textLightGray)
                            Spacer()
                        }
                        VStack {
                            ForEach(0..<detailItem.attributes.count, id: \.self) { index in
                                let attribute = detailItem.attributes[index]
                                let isLast = index == detailItem.attributes.count - 1
                                
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
                }
                
                HStack {
                    Text("Details")
                        .padding(.leading, 20)
                        .foregroundStyle(Color.textLightGray)
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    if !detailItem.formattedAddress.isEmpty {
                        HStack {
                            Text("Address")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(detailItem.formattedAddress)
                                .fontWeight(.semibold)
                                .underline()
                                .onTapGesture(perform: {
                                    print("COPIAR AL PORTAPAPELES")
                                })
                        }
                        
                        Divider()
                            .background(Color.listSeparatorDarkGray)
                    }
                    
                    if detailItem.royaltyFee * 100 > 0.0 {
                        HStack {
                            Text("Creator Royalty Fee")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(detailItem.formattedRoyaltyFee)
                        }
                        .padding(.bottom, 5)
                        
                        Divider()
                            .background(Color.listSeparatorDarkGray)
                    }
                    
                    if !detailItem.formattedAddress.isEmpty {
                        
                        HStack {
                            Text(detailItem.goToWebString)
                                .fontWeight(.semibold)
                                .underline()
                            Spacer()
                        }
                        .onTapGesture {
                            detailItem.goToWeb()
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
        .navigationBarTitle(detailItem.name, displayMode: .inline)
    }
}

struct DetailsView: View {
    let nft: DetailItemViewModel
    
    var body: some View {
        DetailView(detailItem: nft)
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
    
    func createDummyNFT(json: String) -> DetailItemViewModel? {
        // Convertir JSON a AssetItem
        if let assetItem = convertJsonToAssetItem(json: json) {
            // Crear una instancia de NFT a partir de AssetItem
            let nft = DetailItemViewModel(from: assetItem, goToWeb: {
                if true {
                    if let url = URL(string: "https://solscan.io/token/\(assetItem.id ?? "")"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                } else {
                    if let url = URL(string: "https://magiceden.io/item-details/\(assetItem.id ?? "")"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
            })
            return nft
        } else {
            print("Error al convertir JSON a AssetItem.")
            return nil
        }
    }
    
    return DetailsView(nft: createDummyNFT(json: tokenJson)!)
}


