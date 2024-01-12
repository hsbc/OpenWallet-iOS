//
//  LaunchingFirstNFT.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/2/22.
//

import SwiftUI

struct LaunchingFirstNFT: View {
    @ObservedObject var splashScreenManager: SplashScreenManager = SplashScreenManager.shared
    
    var body: some View {
        ClosableView(content: {
            if splashScreenManager.showLaunchingFirstNFTCampaignIntroduction {
                FirstNFTCampaignIntroduction()
            } else {
                imageScreen()
            }
        }, onCloseClick: {
            SplashScreenManager.shared.hideSplashScreen()
        })
    }
}

extension LaunchingFirstNFT {
    func imageScreen() -> some View {
        VStack {
            ScrollView {
                VStack {
                    Image("Splash Screen_First Launch")
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 100, maxWidth: .infinity)
                        .padding(.top, UIScreen.main.bounds.height * 0.092)
                    
                    Group {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Did you know")
                                    .font(Font.custom("SFProText-Light", size: FontSize.headline))
                                Spacer()
                            }
                            Text("OpenWallet is launching")
                                .font(Font.custom("SFProText-Light", size: FontSize.headline))
                            Text("its very first NFT?")
                                .font(Font.custom("SFProText-Light", size: FontSize.headline))
                        }
                        .padding(.bottom, 16)
                        .accessibilityElement(children: .combine)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Learn more about blockchain")
                                    .font(Font.custom("SFProText-Light", size: FontSize.title3))
                                Spacer()
                            }
                            Text("and win your unique NFT.")
                                .font(Font.custom("SFProText-Light", size: FontSize.title3))
                        }
                        .accessibilityElement(children: .combine)
                    }
                    .padding(.horizontal, 18)
                    
                    Spacer()
                }
                .background(.white)
            }
            
            Spacer()
            
            ActionButton(text: "Find out more") {
                splashScreenManager.showLaunchingFirstNFTCampaignIntroduction = true
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 16)
            .accessibilityHint("Click to find out more about the campaign introduction.")
        }
    }
}

struct LaunchingFirstNFT_Previews: PreviewProvider {
    static var previews: some View {
        LaunchingFirstNFT()
    }
}
