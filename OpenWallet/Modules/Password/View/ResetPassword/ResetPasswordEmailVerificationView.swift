//
//  ResetPasswordView.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/13/22.
//

import SwiftUI

struct ResetPasswordEmailVerificationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var navigateToWorkflowRoot: Bool

    @State var email: String = ""
    @State var captchaScenario: CaptchaScenarioEnum = .resetPassword

    @StateObject private var viewModel: PasswordViewModel = PasswordViewModel()
    
    @State private var scenario: ChangePasswordScenario = ChangePasswordScenario.forgotPassword
    @State private var diableNextButton: Bool = !User.shared.isLoggin
    @State private var navigateToNextStep: Bool = false
    @FocusState private var isEmailInputFocused: Bool
    
    @Binding var showChangePasswordView: Bool

    var body: some View {
        mainContent()
            .overlay {
                if viewModel.showEmailCaptchaVerification {
                    verificationContent()
                        .overlay {
                            ToastNotification(showToast: $viewModel.showCommonErrorToast, message: $viewModel.toastErrorMessage)
                        }
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .viewAppearLogger(self)
    }
}

extension ResetPasswordEmailVerificationView {
    func mainContent() -> some View {
        VStack {
            TopBarView(title: viewModel.getBarTitle(scenario), backAction: { dismiss() })
                .overlay(alignment: .trailing) {
                    Button {
                        navigateToWorkflowRoot.toggle()
                    } label: {
                        Text("Cancel")
                            .font(Font.custom("SFProText-Regular", size: FontSize.body))
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom, UIScreen.screenHeight * 0.015)
            
            stepInfo()
                .padding(.bottom, UIScreen.screenHeight * 0.03)

            if User.shared.isLoggin {
                loginStateEmailInfo()
            } else {
                emailInput()
            }
            
            Spacer()
            
            NavigationLink(
                destination: ResetPasswordPhoneNumberVerificationView(
                    viewModel: viewModel,
                    navigateToWorkflowRoot: $navigateToWorkflowRoot,
                    showChangePasswordView: $showChangePasswordView
                ).modifier(HideNavigationBar()),
                isActive: $navigateToNextStep
            ) {
                EmptyView()
            }
            
            ActionButton(text: "Next", isLoading: $viewModel.isSendingCaptcha, isDisabled: $diableNextButton) {
                isEmailInputFocused = false
                viewModel.showEmailCaptchaVerification = true
            }
            .padding(.bottom, UIScreen.screenHeight * 0.02)
        }
        .padding(.horizontal, UIScreen.screenWidth * 0.043)
        .onAppear {
            if User.shared.isLoggin {
                email = User.shared.email
            }
        }
    }
    
    func stepInfo() -> some View {
        VStack {
            HStack {
                Text("Step 1 of 3")
                    .font(Font.custom("SFProText-Medium", size: FontSize.callout))
                Text("Verify email address")
                    .font(Font.custom("SFProText-Regular", size: FontSize.callout))
                Spacer()
            }
            ProgressView(value: 1, total: 3)
                .progressViewStyle(LinearProgressViewStyle(tint: Color("#db0011")))
        }
    }
    
    func emailInput() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Enter email address")
                .font(Font.custom("SFProText-Regular", size: FontSize.label))
            InputTextField(inputText: $email, isFocused: _isEmailInputFocused) { inputEmail in
                diableNextButton = !inputEmail.isEmail
            }
        }
    }
    
    private func loginStateEmailInfo() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Verify the email address connected to your bank account")
                    .font(Font.custom("SFProText-Regular", size: FontSize.label))
                    .foregroundColor(Color("#333333"))
                Spacer()
            }
            
            HStack {
                Text(ContactInfo(value: Contact.email(User.shared.email)).getMaskedValue())
                    .font(Font.custom("SFProText-Regular", size: FontSize.body))
                    .foregroundColor(Color("#333333"))
                Spacer()
            }
        }
    }
    
    func verificationContent() -> some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            ClosableView {
                OTPVerification(
                    contactInfo: ContactInfo(value: Contact.email(email)),
                    email: email,
                    sendCaptcha: sendCaptcha,
                    onCaptchaReady: handleCaptcha,
                    verifyCaptchaErrorMessage: $viewModel.apiErrorMessage
                )
                .padding(.horizontal, UIScreen.screenWidth * 0.043)
                .padding(.top, UIScreen.screenHeight * 0.084)
            } onCloseClick: {
                viewModel.showEmailCaptchaVerification = false
                viewModel.apiErrorMessage = ""
            }
        }
    }
    
    private func sendCaptcha() async {
        await viewModel.sendEmailCaptcha(email, captchaScenario: captchaScenario)
    }
    
    private func handleCaptcha(captcha: String) async throws -> Bool {
        if !navigateToNextStep {
            navigateToNextStep = try await viewModel.verifyEmailCaptcha(email, captcha, captchaScenario: captchaScenario)
        }
        return navigateToNextStep
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    @State static var navigateToWorkflowRoot: Bool = true
    
    static var previews: some View {
        ResetPasswordEmailVerificationView(navigateToWorkflowRoot: $navigateToWorkflowRoot, showChangePasswordView: .constant(false))
    }
}
