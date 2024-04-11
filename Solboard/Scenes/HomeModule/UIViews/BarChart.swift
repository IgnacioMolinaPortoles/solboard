//
//  BarChart.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 11/04/2024.
//

import SwiftUI
import Charts

enum TokenType: String, CaseIterable {
    case fungible
    case nonFungible
    
    var displayableName: String {
        switch self {
        case .fungible: return "Tokens"
        case .nonFungible: return "NFTs"
        }
    }
    
    var color: Color {
        switch self {
        case .fungible: return .cyan
        case .nonFungible: return .orange
        }
    }
}

struct TokenViewModel: Identifiable {
    var id: String = UUID().uuidString
    
    var tokenName: String
    var tokenType: TokenType
    var amount: Float
}

let tokens: [TokenViewModel] = [
    TokenViewModel(tokenName: "Solana", tokenType: .fungible, amount: 4.0),
    TokenViewModel(tokenName: "USDC", tokenType: .fungible, amount: 22.0),
    TokenViewModel(tokenName: "GRASS", tokenType: .fungible, amount: 6.0),
    TokenViewModel(tokenName: "HOWLS", tokenType: .nonFungible, amount: 7.0),
    TokenViewModel(tokenName: "CATS", tokenType: .nonFungible, amount: 14.0)
]

struct BarChart: View {
    var tokensData: [TokenViewModel] = []
    
    var body: some View {
        
            GroupBox {
                HStack {
                    Text("Asset Distribution")
                        .bold()
                    Spacer()
                }
                Spacer().frame(height: 15)
                Chart(tokensData) { item in
                    BarMark(x: .value("Amount", item.amount))
                    .foregroundStyle(item.tokenType.color)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .chartXAxis(.hidden)
                .frame(height: 35)
                Spacer().frame(height: 15)
                HStack(spacing: 6) {
                    ForEach(TokenType.allCases, id: \.self) { type in
                        Circle()
                            .fill(type.color)
                            .frame(width: 12, height: 12)
                        Text(type.displayableName)
                            .font(.system(size: 12, weight: .bold))
                    }
                    Spacer()
                }
                .preferredColorScheme(.dark)
            }
    }
}

#Preview {
    BarChart(tokensData: tokens)
}
