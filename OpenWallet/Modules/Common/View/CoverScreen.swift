//
//  CoverScreen.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 6/28/22.
//

import SwiftUI

struct CoverScreen: View {
    var body: some View {
        ZStack {
            Color(.white).edgesIgnoringSafeArea(.all)

            Image("Thriving hexagons")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.453)
        }
    }
}

struct CoverScreen_Previews: PreviewProvider {
    static var previews: some View {
        CoverScreen()
    }
}
