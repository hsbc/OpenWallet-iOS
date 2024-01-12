//
//  NewHomeView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/29.
//

import SwiftUI

struct NewHomeView: View {
    var body: some View {
        VStack {
            Image("banner_img")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
                .onTapGesture {
                    SplashScreenManager.shared.showLaunchingFirstNFTCampaignIntroduction = true
                    SplashScreenManager.shared.showSplashScreen.toggle()
                }
                .accessibilityLabel("NFT banner")
                .accessibilityAddTraits(.isImage)
                .accessibilityHint("Click to learn more about blockchain and win your unique NFT.")
            Spacer()
        }
    }
}

struct NewHomeView_Previews: PreviewProvider {
    static var previews: some View {
        NewHomeView()
    }
}
