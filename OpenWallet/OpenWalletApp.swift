//
//  OpenWalletApp.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 5/23/22.
//

import SwiftUI

@main
struct OpenWalletApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var authentication = Authentication()
    
    // Launch screen duration in seconds
    private let loadingIndicatorDurationTime: Double = 2
    private let loadingIndicatorShowTime: Double = 2
    
    @State private var isLoading: Bool = false
    @State private var launchScreenDismissed: Bool = false
    @ObservedObject var shakeManager = ShakeManager.shared
    @ObservedObject var appState: AppState = AppState.shared
        
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    RootView()
                }
                .navigationViewStyle(.stack)
                
                if !launchScreenDismissed {
                    LaunchScreen(isLoading: $isLoading)
                }
            }
            .overlay {
                PopUpView(settings: appState.popupSettings, show: $appState.showPopup) {
                    NavigationStateForWelcome.shared.backToWelcome = UUID()
                }
            }
            .sheet(isPresented: $shakeManager.didShake, onDismiss: {
                OHLogger.shared.didShow = false
            }, content: {
                if !OHLogger.shared.isArchiving && !OHLogger.shared.didShow {
                    let path = OHLogger.shared.archiveLogFile()
                    ActivityViewController(activityItems: [URL(fileURLWithPath: path)])
                }
            })
            .environmentObject(authentication)
            .onAppear {

                // Show loading indicator after certain seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + loadingIndicatorShowTime) {
                    isLoading = true

                    Task {
                        // In case of app first launching after installed, force iOS network-permissions alert view showing before user login action
                        try? await AuthService().getCountryCodeInfo()
                    }
                    
                    // Dismiss launch screen after after certain seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + loadingIndicatorDurationTime) {
                        launchScreenDismissed = true
                        
                        // shake to share log file
                        // Only used in UAT test
                        #if canImport(CocoaLumberjackSwift)
                        ShakeManager.shared.startAccelerometer()
                        #endif
                    }
                }
                // If app has been reinstalled, take care user info that are previously stored in keychain. [weihao.zhang]
                User.shared.handlePersistedUserInfo()
                
                // Auto dismiss keyboard when tapping anywhere in the view
                HideKeyboardManager.shared.startAutoDismissKeyboard()
            }
        }
    }
}
