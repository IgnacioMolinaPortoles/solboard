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
    
    func updateTokens(tokens: [TokenViewModel]) {
        self.tokens = tokens
    }
}

struct BarChart: View {
    @ObservedObject private var viewModel: BarChartViewModel
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
                }
                Spacer().frame(height: 15)
                Chart(viewModel.tokens) { item in
                    BarMark(x: .value("Amount", 1))
                        .foregroundStyle(Color(hex: item.tokenType.hexColor))
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .chartXAxis(.hidden)
                .frame(height: 35)
                
                Spacer().frame(height: 15)
                HStack(spacing: 6) {
                    ForEach([TokenType.fungible, TokenType.nonFungible], id: \.self) { type in
                        HStack {
                            Circle()
                                .fill(Color(hex: type.hexColor))
                                .frame(width: 12, height: 12)
                            Text(type.displayableName)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
                    Spacer()
                }
                    
            }
            .backgroundStyle(Color.backgroundDarkGray)
            .background(.black)
            .onTapGesture {
                onAssetTapDo()
            }
        
    }
}

//#Preview {
//    BarChart(tokensData: tokens, onAssetDistributionTapDo: {})
//}

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
