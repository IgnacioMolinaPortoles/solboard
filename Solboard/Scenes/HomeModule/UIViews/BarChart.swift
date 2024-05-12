//
//  BarChart.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 11/04/2024.
//

import SwiftUI
import Charts
import Combine


class BarChartViewModel: ObservableObject {
    @Published var tokens: [TokenViewModel]
    
    init(tokens: [TokenViewModel]) {
        self.tokens = tokens
    }
    
    // Actualiza la lista de tokens
    func updateTokens(tokens: [TokenViewModel]) {
        self.tokens = tokens
    }
    
    // Genera datos visuales para el gráfico de barras
    var chartData: [(TokenViewModel, Color)] {
        return tokens.map { token in
            let color = Color(hex: token.tokenType.hexColor)
            return (token, color)
        }
    }
    
    // Calcula los colores de los tipos de tokens
    var tokenTypeColors: [(TokenType, Color)] {
        return [TokenType.fungible, TokenType.nonFungible].map { type in
            let color = Color(hex: type.hexColor)
            return (type, color)
        }
    }
}

struct BarChart: View {
    @ObservedObject var viewModel: BarChartViewModel
    var onAssetTapDo: () -> Void

    init(viewModel: BarChartViewModel, onAssetTapDo: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onAssetTapDo = onAssetTapDo
    }

    var body: some View {
        GroupBox {
            HStack {
                Text("Asset Distribution")
                    .bold()
                    .foregroundStyle(.white)
                Spacer()
                Image(.chevronRight)
            }
            Spacer().frame(height: 15)

            Chart(viewModel.chartData, id: \.0.id) { item, color in
                BarMark(x: .value("Amount", 1))
                    .foregroundStyle(color)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .chartXAxis(.hidden)
            .frame(height: 35)

            Spacer().frame(height: 15)

            HStack(spacing: 6) {
                ForEach(viewModel.tokenTypeColors, id: \.0) { type, color in
                    HStack {
                        Circle()
                            .fill(color)
                            .frame(width: 12, height: 12)
                        Text(type.displayableName)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                Spacer()
            }
        }
        .backgroundStyle(Color.backgroundDarkGray1C)
        .background(.black)
        .onTapGesture {
            onAssetTapDo()
        }
    }
}

#Preview {
    let dummy = TokenViewModel(tokenName: "Si", tokenType: .fungible)
    let vm = BarChartViewModel(tokens: [dummy, dummy])
    return BarChart(viewModel: vm, onAssetTapDo: {})
}

extension UIView {
    func addAssetBarChart(tokensData: [TokenViewModel], onAssetTapDo: @escaping () -> Void) -> BarChartViewModel {
        let barChartViewModel = BarChartViewModel(tokens: tokensData)
        let rootView = BarChart(viewModel: barChartViewModel, onAssetTapDo: onAssetTapDo)
        
        let barChartView = UIHostingController(rootView: rootView)
        
        self.addSubview(barChartView.view)
        barChartView.view.attach(toView: self)
        
        return barChartViewModel
    }
}
