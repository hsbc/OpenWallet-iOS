//
//  LogonView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/8/26.
//

import SwiftUI

struct LogonView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel = LogonViewModel()
    
    var navigateBackToWelcome: Binding<Bool>?

    @State var attemptTologOnWithDifferentUser: Bool = false
    @State var navigateToPsw: Bool = false
    @State var disableNextButton: Bool = true
    @State var showUsernameWarning: Bool = false
    @State var foundedUserName: String?
    @State var disableSwitchUser: Bool = false
    
    @FocusState private var isUsernameInputFieldFocused: Bool
    
    private let desiredUsernameLength: Int = 6
    
    var body: some View {
        VStack(spacing: 0) {
            headerBar()
                .padding(.bottom, UIScreen.screenHeight * 0.032)
            
            greetingInfo()
                .padding(.bottom, UIScreen.screenHeight * 0.039)
            
            usernameSection()
                .padding(.bottom, UIScreen.screenHeight * 0.034)
            
            forgotUsernameSection()
            
            navigationLinks()
            
            Spacer()
        }
        .padding(.horizontal, UIScreen.screenWidth * 0.043)
        .overlay(alignment: .bottom) {
            termsAndConditionsNote()
                .padding(.bottom, UIScreen.screenHeight * 0.01)
        }
        .overlay {
            BottomPopup(show: $viewModel.showUsernameHelp, title: "Username", content: viewModel.usernameHelpInfo)
        }
        .onAppear {
            // If foundedUserName is provided, use that name.
            // Otherwise, find username from keychain unless the user attempts to log on with a different username. [weihao.zhang]
            if let foundedName = foundedUserName {
                viewModel.userName = foundedName
            } else if !attemptTologOnWithDifferentUser {
                viewModel.checkIfHaveUserNameInKeyChain()
            }
            
            disableNextButton = viewModel.userName.count < desiredUsernameLength
            showUsernameWarning = false
        }
        .viewAppearLogger(self)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

}

extension LogonView {
    
    func headerBar() -> some View {
        ZStack {
            TopBarView(backAction: {
                viewModel.clearUsernameSettings()
                
                if navigateBackToWelcome != nil {
                    navigateBackToWelcome?.wrappedValue = false // set this Binding property to false to navigate back to its root view. [weihao.zhang]
                } else {
                    dismiss()
                }
            })
            
            Image("Thriving hexagons")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.screenWidth * 0.085)
        }
        .padding(.top, UIScreen.screenHeight * 0.012)
    }
    
    func navigationLinks() -> some View {
        Group {
            NavigationLink(
                destination: LogonPwdView(viewModel: viewModel, navigateBackToWelcome: navigateBackToWelcome, disableSwitchUser: disableSwitchUser).navigationBarHidden(true),
                isActive: $navigateToPsw
            ) {
                EmptyView()
            }
            .accessibilityHidden(true)
            
            NavigationLink(
                destination: ErrorView(errorMessage: "One or more of the details you entered does not match the information on our records.") {
                    NavigationLink(
                        destination: WelcomeView().modifier(HideNavigationBar())
                    ) {
                        ActionButton(text: "Go back")
                            .disabled(true)
                    }
                }.modifier(HideNavigationBar()),
                isActive: $viewModel.navigateToErrorPage
            ) {
                EmptyView()
            }
            .accessibilityHidden(true)
        }
    }
    
    func greetingInfo() -> some View {
        VStack(spacing: UIScreen.screenHeight * 0.01) {
            Text("Good \(Date.now.toTimeOfDay)")
                .font(Font.custom("SFProDisplay-Regular", size: FontSize.largeHeadline))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Log on to \(EnvironmentConfig.appDisplayName).")
                .font(Font.custom("SFProText-Regular", size: FontSize.body))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    func usernameSection() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            enterYourUsernameLabel()
                .padding(.bottom, UIScreen.screenHeight * 0.005)
            
            usernameInputBox()
                .padding(.bottom, UIScreen.screenHeight * 0.025)
            
            Button {
                viewModel.isRemember.toggle()
            } label: {
                HStack {
                    Image(systemName: viewModel.isRemember ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(viewModel.isRemember ? Color("#00847f") : .black)
                    Text("Remember me")
                        .font(Font.custom("SFProText-Regular", size: FontSize.warning))
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, UIScreen.screenHeight * 0.039)
            
            ActionButton(text: "Next", isLoading: $viewModel.isLoading, isDisabled: $disableNextButton, action: {
                guard viewModel.userName.isAcceptableUsername else {
                    showUsernameWarning = true
                    return
                }
                
                navigateToPsw = true
            })
        }
    }
    
    func enterYourUsernameLabel() -> some View {
        HStack(spacing: 0) {
            Text("Enter your username")
                .font(Font.custom("SFProText-Regular", size: FontSize.body))
            
            Button {
                isUsernameInputFieldFocused = false
                viewModel.showUsernameHelp.toggle()
            } label: {
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16)
                    .foregroundColor(Color("#333333"))
            }
            .frame(width: 24, height: 24, alignment: .center)
            .contentShape(Rectangle())
            .accessibilityLabel("Click to get more tips about username")
        }
    }
    
    func usernameInputBox() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            InputTextField(inputText: $viewModel.userName, height: UIScreen.screenHeight * 0.076, isFocused: _isUsernameInputFieldFocused) { _ in
                checkNextButtonState()
                showUsernameWarning = false
            } onFocusChange: { _ in
                checkNextButtonState()
            }

            if showUsernameWarning {
                HStack {
                    Image("Warning on light")
                        .resizable()
                        .background(Color.black)
                        .clipShape(Circle())
                        .scaledToFit()
                        .frame(width: 20)
                    Text("Please enter a valid username.")
                        .font(Font.custom("SFProText-Regular", size: FontSize.info))
                }
                .padding(.top, UIScreen.screenHeight * 0.015)
            }
        }
    }
    
    func forgotUsernameSection() -> some View {
        NavigationLink(
            destination: FindUsernameEmailVeirfyView().navigationBarHidden(true)
        ) {
            Text("Forgot your username?")
                .font(Font.custom("SFProText-Regular", size: FontSize.body))
                .foregroundColor(.black)
        }
    }
    
    func termsAndConditionsNote() -> some View {
        Text("By logging on, you agree to the Terms and Conditions.")
            .foregroundColor(Color("#333333"))
            .font(Font.custom("SFProText-Regular", size: FontSize.caption))
    }
    
    func checkNextButtonState() {
        disableNextButton = viewModel.userName.count < desiredUsernameLength
    }
    
}

struct LogonView_Previews: PreviewProvider {
    @State static var navigateToWelcome: Bool = false
    
    static var previews: some View {
        LogonView(navigateBackToWelcome: $navigateToWelcome)
    }
}
