//
//  WonLuckyDraw.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/2/22.
//

import SwiftUI

struct WonLuckyDraw: View {
    @ObservedObject var splashScreenManager: SplashScreenManager = SplashScreenManager.shared
    
    @State var navigateToWalletModule: Bool = false
    
    var body: some View {
        ClosableView(content: {
            GeometryReader { geometry in
                VStack {
                    Image("Splash Screen_Winning-banner")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .frame(width: geometry.size.width)
                    
                    Group {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Congratulations!")
                                    .font(Font.custom("SFProText-Light", size: FontSize.extraLargeHeadline))
                                Spacer()
                            }
                            HStack {
                                Text("You've won a very unique")
                                    .font(Font.custom("SFProText-Light", size: FontSize.title3))
                                Spacer()
                            }
                            Text("OpenWallet branded NFT.")
                                .font(Font.custom("SFProText-Light", size: FontSize.title3))
                        }
                        .padding(.bottom, 16)
                        
                        Spacer()
                        
                        NavigationLink(
                            destination: MainView().modifier(HideNavigationBar()),
                            isActive: $navigateToWalletModule
                        ) {
                            EmptyView()
                        }
                        
                        ActionButton(text: "Collect your NFT") {
                            AppState.shared.selectedTab = Tab.wallet
                            navigateToWalletModule.toggle()
                        }
                        .padding(.bottom, 16)
                    }
                    .padding([.leading, .trailing], 18)
                }
                .background(.white)
                .viewAppearLogger(self)
            }
        }, onCloseClick: {
            SplashScreenManager.shared.hideSplashScreen()
        })
    }
}

struct WonLuckyDraw_Previews: PreviewProvider {
    static var previews: some View {
        WonLuckyDraw()
    }
}
