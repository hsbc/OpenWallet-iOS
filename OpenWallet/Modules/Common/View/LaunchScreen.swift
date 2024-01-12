//
//  LaunchScreen.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 6/30/22.
//

import Combine
import SwiftUI

struct LaunchScreen: View {
    @Binding var isLoading: Bool
    
    var body: some View {
        ZStack {
            background

            Image("Thriving hexagons")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.453)
            
            if isLoading {
                VStack {
                    Spacer()
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(1.5)
                }
                .padding(.bottom, 34)
            }
        }
    }
}

private extension LaunchScreen {
    var background: some View {
        Color(.white).edgesIgnoringSafeArea(.all)
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    @State static var isLoading: Bool = true
    
    static var previews: some View {
        LaunchScreen(isLoading: $isLoading)
    }
}
