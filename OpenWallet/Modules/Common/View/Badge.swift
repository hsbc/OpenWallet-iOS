//
//  Badge.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 6/17/22.
//

import SwiftUI

struct Badge: View {
    @State var size: CGFloat = 8
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
            Text("")
                .frame(width: size, height: size)
                .background(Color("#db0011"))
                .foregroundColor(.white)
                .clipShape(Circle())
        }
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        let showBadge: Bool = true
        
        VStack {
            Image("Icon-notification")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .overlay(showBadge ? Badge() : nil)
        }
    }
}
