//
//  SwipeDownToRefreshIndicator.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 10/19/22.
//

import SwiftUI

struct SwipeDownToRefreshIndicator: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("touch")
            Text("Please swipe down to refresh!")
                .font(Font.custom("SFProText-Regular", size: FontSize.info))
        }
    }
}

struct SwipeDownToRefreshIndicator_Previews: PreviewProvider {
    static var previews: some View {
        SwipeDownToRefreshIndicator()
    }
}
