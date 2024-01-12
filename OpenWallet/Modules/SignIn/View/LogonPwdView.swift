//
//  LogonPwdView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/25.
//

import SwiftUI

struct LogonPwdView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: LogonViewModel
    
    var navigateBackToWelcome: Binding<Bool>?
    
    @State var showPassword: Bool = false
    
    @FocusState private var isPasswordInputFieldFocused: Bool
    
    @State private var navigateToLogOnUsername: Bool = false
    @State private var navigateToForgetPasswordRoot: Bool = false
    @State private var allowSwitchUser: Bool = false
    @State var disableSwitchUser: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            headerBar()
                .padding(.bottom, UIScreen.screenHeight * 0.073)
            
            passwordSection()
                .padding(.bottom, UIScreen.screenHeight * 0.034)
            
            forgotPasswordSection()

            navigationLinks()
            
            Spacer()
        }
        .padding(.horizontal, UIScreen.screenWidth * 0.043)
        .overlay(alignment: .bottom) {
            termsAndConditionsNote()
                .padding(.bottom, UIScreen.screenHeight * 0.01)
        }
        .overlay {
            BottomPopup(show: $viewModel.showPasswordRule, title: "Password rule", content: viewModel.passwordRule)
        }
        .onAppear {
            initStatus()
        }
        .viewAppearLogger(self)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
}

extension LogonPwdView {

    func headerBar() -> some View {
        ZStack {
            TopBarView(backAction: {
//                viewModel.clearPasswordSettings()
                dismiss()
            })
            
            Image("Thriving hexagons")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.screenWidth * 0.085)
        }
        .padding(.top, UIScreen.screenHeight * 0.012)
    }
    
    func navigationLinks() -> some View {
        NavigationLink(
            destination: SelectVerification(viewModel: viewModel).navigationBarHidden(true),
            isActive: $viewModel.showSelectVerification
        ) {
            EmptyView()
        }
        .accessibilityHidden(true)
    }
    
    func passwordSection() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            enterPasswordLabel()
                .padding(.bottom, UIScreen.screenHeight * 0.005)
            
            VStack(alignment: .leading, spacing: 0) {
                SecureTextField(
                    inputText: $viewModel.password,
                    isTextVisable: $showPassword,
                    isErrorState: $viewModel.isInvalidPassword,
                    height: UIScreen.screenHeight * 0.076,
                    iconWidth: 24,
                    isFocused: _isPasswordInputFieldFocused
                )
                .onChange(of: viewModel.password, perform: { _ in
                    viewModel.disableLogOnButton = !viewModel.password.isPasswordFullfilledLengthRequirement
                    
                    if viewModel.isInvalidPassword {
                        viewModel.isInvalidPassword = false
                    }
                })
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("You can input password here.")
                
                if viewModel.isInvalidPassword {
                    HStack {
                        Image("Error on light")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.screenWidth * 0.053)
                            .foregroundColor(Color("#a8000b"))

                        Text(viewModel.passwordErrorMessage)
                            .font(Font.custom("SFProText-Regular", size: FontSize.warning))
                    }
                    .padding(.top, UIScreen.screenHeight * 0.017)
                }

                if allowSwitchUser {
                    switchUserSection()
                        .padding(.top, UIScreen.screenHeight * 0.02)
                }
            }
            .padding(.bottom, UIScreen.screenHeight * 0.054)

            ActionButton(text: "Next", isLoading: $viewModel.isLoggingOn, isDisabled: $viewModel.disableLogOnButton) {
                Task {
                    await viewModel.verifyFirstFactor()
                }
            }
        }
    }
    
    func switchUserSection() -> some View {
        Group {
            NavigationLink(
                destination: LogonView(navigateBackToWelcome: navigateBackToWelcome, attemptTologOnWithDifferentUser: true, disableSwitchUser: true).navigationBarHidden(true),
                isActive: $navigateToLogOnUsername
            ) {
                EmptyView()
            }

            Button {
                navigateToLogOnUsername = true
            } label: {
                    HStack {
                        Text("Switch user")
                            .font(Font.custom("SFProText-Regular", size: FontSize.body))
                            .foregroundColor(Color("#333333"))
                        Image("Chevron Right")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
                            .foregroundColor(Color("#C03954"))
                    }
            }
            .buttonStyle(.plain)

        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("Click to switch to a different user.")
    }
    
    func enterPasswordLabel() -> some View {
        HStack(spacing: 0) {
            Text("Enter password")
                .font(Font.custom("SFProText-Regular", size: FontSize.body))
            Button {
                isPasswordInputFieldFocused = false
                viewModel.showPasswordRule.toggle()
            } label: {
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16)
                    .foregroundColor(Color("#333333"))
            }
            .frame(width: 24, height: 24, alignment: .center)
            .contentShape(Rectangle())
            .accessibilityLabel("Click to get more tips about password")
            
            Spacer()
        }
    }
    
    func forgotPasswordSection() -> some View {
            NavigationLink {
                ResetPasswordEmailVerificationView(navigateToWorkflowRoot: $navigateToForgetPasswordRoot, showChangePasswordView: .constant(true)).modifier(HideNavigationBar())
            } label: {
                Text("Forgot your password?")
                    .font(Font.custom("SFProText-Medium", size: FontSize.body))
                    .foregroundColor(Color("#333333"))
            }
            .id(navigateToForgetPasswordRoot)
            .accessibilityHint("Click to find your password.")
    }
    
    func termsAndConditionsNote() -> some View {
        Text("By logging on, you agree to the Terms and Conditions.")
            .foregroundColor(Color("#333333"))
            .font(Font.custom("SFProText-Regular", size: FontSize.caption))
    }
    
    private func initStatus() {
        allowSwitchUser = UserDefaultsManager.isRememberedUsername() && !disableSwitchUser
        viewModel.disableLogOnButton = !viewModel.password.isPasswordFullfilledLengthRequirement
    }
    
}

struct LogonPwdView_Previews: PreviewProvider {
    @State static var navigateToWelcome: Bool = false
    
    static var previews: some View {
        LogonPwdView(viewModel: LogonViewModel(), navigateBackToWelcome: $navigateToWelcome)
    }
}
