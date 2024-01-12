//
//  RootView.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 6/28/22.
//

import SwiftUI

struct RootView: View {
    var appState: AppState = AppState.shared
    var user: User = User.shared
    var notificationManager: NotificationManager = NotificationManager.shared
    var splashScreenManager: SplashScreenManager = SplashScreenManager.shared
    
    var body: some View {

        WelcomeView()
            .modifier(HideNavigationBar())

    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
