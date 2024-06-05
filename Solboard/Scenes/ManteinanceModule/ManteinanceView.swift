//
//  ManteinanceView.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 24/05/2024.
//

import SwiftUI

struct ManteinanceView: View {
    var body: some View {
        VStack {
            Image(systemName: "network")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180)
            VStack {
                Text("Sorry")
                    .padding(.bottom, 10)
                    .font(.system(size: 30, weight: .bold))
                
                VStack {
                    Text("We could not load your information")
                }
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: .semibold))
                .padding(.horizontal, 20)
            }
            .padding(.top, 30)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(.black)
        .foregroundStyle(.white)

        
    }
}

#Preview {
    ManteinanceView()
}
