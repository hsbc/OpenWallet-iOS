//
//  SplashScreenManager.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/2/22.
//

import Foundation
import SwiftUI

class SplashScreenManager: ObservableObject {
    static let shared = SplashScreenManager()
    
    @Published var showSplashScreen: Bool = false
    @Published var showLaunchingFirstNFTCampaignIntroduction: Bool = false
    
    @ViewBuilder
    func getSplashScreen() -> some View {
        if User.shared.hasWonLuckyDraw {
            WonLuckyDraw()
        } else {
            LaunchingFirstNFT()
        }
    }
    
    func hideSplashScreen() {
        showSplashScreen = false
    }
}
