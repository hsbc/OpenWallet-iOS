//
//  WelcomeView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/25.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var navigationState: NavigationStateForWelcome = NavigationStateForWelcome.shared
    
    @State var navigateToLogon: Bool = false
    
    @State var navigateToRegister: Bool = false
    @State var navigateToDebug = false
    @State private var logOnComponent: AnyView = AnyView(EmptyView())
    
    var body: some View {
        // swiftlint:disable all
        let _ = DebugHelper.debugPrintViewRebuildLog(Self.self)
        
        VStack {
            navigationLinks()
            
            Image("welcome-top")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all, edges: [.top, .leading, .trailing])
                .frame(width: UIScreen.screenWidth)
            VStack(spacing: 0) {
                Text("Welcome to OpenWallet Open")
                    .font(Font.custom("SFProDisplay-Regular", size: FontSize.largeHeadline))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Before registering, please keep on hand the email address and mobile phone number connected to your bank account.")
                    .font(Font.custom("SFProText-Light", size: FontSize.body))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, UIScreen.screenHeight*0.015)
            }
            .padding(.horizontal, 16)
            .offset(y: -UIScreen.screenHeight*0.04)
            
            Spacer()
            
            if UtilHelper().isSimulator() {
                Button {
                    navigateToDebug = true
                } label: {
                    Text("Debug here")
                        .underline()
                        .foregroundColor(.gray)
                        .font(Font.custom("SFProText-Medium", size: 12))
                }
            }
            
            Button {
                logOnComponent = AnyView(getLogOnComponent())
                navigateToLogon = true
            } label: {
                Text("Log on")
                    .foregroundColor(.white)
                    .font(Font.custom("SFProText-Medium", size: FontSize.button))
                    .frame(width: UIScreen.main.bounds.width*0.914, height: UIScreen.screenHeight*0.065, alignment: .center)
                    .background(Color("#db0011"))
            }
            
            Button {
                navigateToRegister = true
            } label: {
                Text("Register")
                    .foregroundColor(.black)
                    .font(Font.custom("SFProText-Medium", size: FontSize.button))
                    .frame(width: UIScreen.main.bounds.width*0.914, height: UIScreen.screenHeight*0.065, alignment: .center)
            }
            .border(.black)
            .padding(.bottom, 16)
        }
        .id(navigationState.backToWelcome)
        .viewAppearLogger(self)
    }

}

extension WelcomeView {
    func navigationLinks() -> some View {
        Group {
            NavigationLink(
                destination: logOnComponent.navigationBarHidden(true),
                isActive: $navigateToLogon
            ) {
                EmptyView()
            }
            .isDetailLink(false)
            // .id(navigationState.backToWelcome) // This is to support navigate back the welcome page from further navigation stack. [weihao.zhang]
            .accessibilityHidden(true)
            
            NavigationLink(
                destination: OnBoarding().navigationBarHidden(true),
                isActive: $navigateToRegister
            ) {
                EmptyView()
            }
            // .id(navigationState.backToWelcome)
            .accessibilityHidden(true)
            
            NavigationLink(
                destination: DebugRoom(),
                isActive: $navigateToDebug
            ) {
                EmptyView()
            }
            .accessibilityHidden(true)
        }

    }
    
    private func getLogOnComponent() -> some View {
        if let _ = KeychainManager.loadUserNameByBundleId(), UserDefaultsManager.isRememberedUsername() {
            let logOnViewModel = LogonViewModel()
            logOnViewModel.checkIfHaveUserNameInKeyChain()
            OHLogInfo("load LogonPwdView")
            return AnyView(LogonPwdView(viewModel: logOnViewModel, navigateBackToWelcome: $navigateToLogon))
        } else {
            OHLogInfo("load LogonView")
            return AnyView(LogonView(navigateBackToWelcome: $navigateToLogon))
        }
    }

}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
