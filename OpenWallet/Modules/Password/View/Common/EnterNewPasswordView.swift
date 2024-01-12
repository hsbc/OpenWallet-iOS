//
//  ChangePasswordEnterPassword.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/27/22.
//

import SwiftUI

struct EnterNewPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: PasswordViewModel
    @State var scenario: ChangePasswordScenario
    
    @Binding var navigateToWorkflowRoot: Bool
    @Binding var showChangePasswordView: Bool
    
    @FocusState private var isPasswordFieldFocused: Bool
    @FocusState private var isConfirmPasswordFieldFocused: Bool
    
    @State private var logOnComponent: AnyView = AnyView(EmptyView())
    @State private var showPasswordRule: Bool = false
    
    var body: some View {
        VStack {
            mainContent()
            navigationLinks()
        }
        .padding(.horizontal, UIScreen.screenWidth * 0.043)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .overlay {
            BottomPopup(show: $showPasswordRule, title: "Password rule", content: AppState.passwordRule)
        }
        .onAppear {
            logOnComponent = AnyView(getLogOnComponent())
            initStatus()
        }
        .viewAppearLogger(self)
    }
}

extension EnterNewPasswordView {
    func mainContent() -> some View {
        VStack {
            TopBarView(title: viewModel.getBarTitle(scenario), backAction: {
                isPasswordFieldFocused = false
                isConfirmPasswordFieldFocused = false

                // A workaround to hide email/sms OTP verification in previous step. [weihao.zhang]
                viewModel.showEmailCaptchaVerification = false
                viewModel.showPhoneCaptchaVerification = false

                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    dismiss()
                }
            })
            .overlay(alignment: .trailing) {
                if scenario == .changePassword {
                    Button {
                        showChangePasswordView = false
                    } label: {
                        Text("Cancel")
                            .font(Font.custom("SFProText-Regular", size: FontSize.body))
                            .foregroundColor(.black)
                    }
                } else {
                    Button {
                        navigateToWorkflowRoot.toggle()
                    } label: {
                        Text("Cancel")
                            .font(Font.custom("SFProText-Regular", size: FontSize.body))
                            .foregroundColor(.black)
                    }
                }
            }
            
            VStack(spacing: UIScreen.screenHeight * 0.03) {
                stepInfo()
                passwordSection()
                
                Spacer()
                
                ActionButton(text: "Submit", isLoading: $viewModel.isResettingPassword, isDisabled: .constant(!viewModel.passwordsAreReady)) {
                    // change password use different endpoint with reset password
                    switch scenario {
                    case .changePassword:
                        viewModel.changePassword()
                    case .forgotPassword:
                        viewModel.resetPassword()
                    }
                }
                .padding(.bottom, UIScreen.screenHeight * 0.02)
            }
            .overlay(alignment: .top) {
                ToastNotification(showToast: $viewModel.failedToResetPassword, message: .constant(AppState.defaultErrorMesssage))
            }
        }
    }
    
    func navigationLinks() -> some View {
        Group {
            NavigationLink(
                destination: SuccessView(
                    detailInfo: viewModel.getChangePasswordSuccessfullyMessage(scenario),
                    buttonText: "Log on",
                    imageName: "congratulations-password",
                    buttonActionAsync: {},
                    destination: {
                        logOnComponent.modifier(HideNavigationBar())
                    }
                ).modifier(HideNavigationBar()),
                isActive: $viewModel.resetPasswordSuccessfully
            ) {
                EmptyView()
            }
            
            if !User.shared.isLoggin && scenario == .forgotPassword {
                NavigationLink(
                    destination: ErrorView(errorMessage: "One or more of the details you entered does not match the information on our records.") {
                        NavigationLink(
                            destination: WelcomeView().modifier(HideNavigationBar())
                        ) {
                            ActionButton(text: "Go back")
                                .disabled(true)
                        }
                    }.modifier(HideNavigationBar()),
                    isActive: $viewModel.navigateToErrorPageFromEnteringNewPassword
                ) {
                    EmptyView()
                }
            } else {
                NavigationLink(
                    destination: ErrorView {
                        VStack(spacing: 7) {
                            ActionButton(text: "Try again") {
                                viewModel.navigateToErrorPageFromEnteringNewPassword = false
                            }
                            
                            ActionButton(text: "Go back to home", isPrimaryButton: false) {
                                AppState.shared.selectedTab = .home
                                showChangePasswordView = false
                            }
                        }
                    }.modifier(HideNavigationBar()),
                    isActive: $viewModel.navigateToErrorPageFromEnteringNewPassword
                ) {
                    EmptyView()
                }
            }
        }
        .accessibility(hidden: true)
    }
    
    func stepInfo() -> some View {
        VStack {
            HStack {
                Text("Step 3 of 3")
                    .font(Font.custom("SFProText-Medium", size: FontSize.callout))
                Text(viewModel.getEnterPasswordStepInfoText(scenario))
                    .font(Font.custom("SFProText-Regular", size: FontSize.callout))
                Spacer()
            }
            .padding([.top, .bottom], 12)
            
            ProgressView(value: 3, total: 3)
                .progressViewStyle(LinearProgressViewStyle(tint: Color("#db0011")))
        }
    }
    
    func passwordSection() -> some View {
        VStack(spacing: UIScreen.screenHeight * 0.02) {
            newPasswordSection()
            confirmPasswordSection()
        }
    }
    
    func newPasswordSection() -> some View {
        VStack {
            VStack(alignment: .leading, spacing: 4) {
                enterNewPasswordLabel()
                
                SecureTextField(
                    inputText: $viewModel.newPassword,
                    isTextVisable: $viewModel.showNewPassword,
                    isErrorState: $viewModel.isInvalidNewPassword
                )
                .focused($isPasswordFieldFocused)
                .onChange(of: isPasswordFieldFocused) { isFocused in
                    viewModel.checkIfPasswordsAreConfirmed()
                    guard !viewModel.newPassword.isEmpty && !isFocused else { return }
                    viewModel.showPasswordTips = !viewModel.newPassword.isAcceptablePassword
                    viewModel.isInvalidNewPassword = !viewModel.newPassword.isAcceptablePassword
                }
                .onChange(of: viewModel.newPassword) { _ in
                    viewModel.showPasswordTips = false
                    viewModel.isInvalidNewPassword = false
                }
            }
            
            if viewModel.showPasswordTips {
                HStack(alignment: .top, spacing: UIScreen.screenWidth * 0.032) {
                    Image("Information on light")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color("#305a85"))
                        .padding(.trailing, 12)
                    
                    Text(viewModel.passwordTips)
                        .font(Font.custom("SFProText-Regular", size: FontSize.warning))
                    
                    Spacer()
                }
                .frame(width: UIScreen.screenWidth * 0.915)
                .padding(.vertical, 12)
            }
        }
    }
    
    func confirmPasswordSection() -> some View {
        VStack {
            SecureTextField(
                label: "Confirm password",
                inputText: $viewModel.confirmPassword,
                isTextVisable: $viewModel.showConfirmPassword,
                isErrorState: $viewModel.isInvalidConfirmPassword
            )
            .focused($isConfirmPasswordFieldFocused)
            .onChange(of: isConfirmPasswordFieldFocused) { isFocused in
                viewModel.checkIfPasswordsAreConfirmed()
                guard !viewModel.confirmPassword.isEmpty && !isFocused else { return }
                viewModel.isInvalidConfirmPassword = !viewModel.confirmPassword.isAcceptablePassword
            }
            .onChange(of: viewModel.confirmPassword) { _ in
                viewModel.showPasswordConfirmationError = false
                viewModel.isInvalidConfirmPassword = false
            }
            
            if viewModel.showPasswordConfirmationError {
                HStack(alignment: .top, spacing: UIScreen.screenWidth * 0.032) {
                    Image("Error on light")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .foregroundColor(Color("#a8000b"))
                    
                    Text(viewModel.passwordConfirmationErrorMessage)
                        .font(Font.custom("SFProText-Regular", size: FontSize.warning))

                    Spacer()
                }
                .padding(.vertical, 12)
            }
        }
    }
    
    func enterNewPasswordLabel() -> some View {
        HStack(spacing: 0) {
            Text("New password")
                .font(Font.custom("SFProText-Regular", size: FontSize.label))
            Button {
                showPasswordRule.toggle()
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
    
    private func getLogOnComponent() -> some View {
        if  (KeychainManager.loadUserNameByBundleId() != nil), UserDefaultsManager.isRememberedUsername() {
            let logOnViewModel = LogonViewModel()
            logOnViewModel.checkIfHaveUserNameInKeyChain()
            OHLogInfo("load LogonPwdView")
            return AnyView(LogonPwdView(viewModel: logOnViewModel))
        } else {
            OHLogInfo("load LogonView")
            return AnyView(LogonView())
        }
    }
    
    private func initStatus() {
        viewModel.showNewPassword = false
        viewModel.showConfirmPassword = false
        
        viewModel.showPasswordTips = false
        viewModel.showPasswordConfirmationError = false

        viewModel.isInvalidNewPassword = !viewModel.newPassword.isEmpty && !viewModel.newPassword.isAcceptablePassword
        viewModel.isInvalidConfirmPassword = !viewModel.confirmPassword.isEmpty && !viewModel.confirmPassword.isAcceptablePassword
    }
}

struct ChangePasswordEnterPassword_Previews: PreviewProvider {
    @State static var viewModel: PasswordViewModel = PasswordViewModel()
    @State static var navigateToWorkflowRoot: Bool = true
    
    static var previews: some View {
        EnterNewPasswordView(viewModel: viewModel, scenario: ChangePasswordScenario.changePassword, navigateToWorkflowRoot: $navigateToWorkflowRoot, showChangePasswordView: .constant(false))
    }
}
