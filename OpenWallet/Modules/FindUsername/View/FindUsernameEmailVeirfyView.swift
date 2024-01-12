//
//  FindUsernameEmailVeirfyView.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/21.
//

import SwiftUI

struct FindUsernameEmailVeirfyView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = FindUsernameViewModel()
    @State private var diableNextButton: Bool = true
    @State private var navigateToNextStep: Bool = false
    @FocusState private var isEmailInputBoxFocused: Bool
    
    var body: some View {
        mainContent()
            .overlay {
                if viewModel.showEmailVerification {
                    verificationContent()
                        .onDisappear {
                            viewModel.apiErrorMessageForEmailVerification = ""
                        }
                }
            }
            .viewAppearLogger(self)
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

extension FindUsernameEmailVeirfyView {
    func mainContent() -> some View {
        VStack {
            TopBarView(title: "Find my username", backAction: { dismiss() })
                .padding(.bottom, UIScreen.screenHeight * 0.015)

            stepInfo()
                .padding(.bottom, UIScreen.screenHeight * 0.03)
            
            emailInput()
            
            Spacer()
            
            NavigationLink(
                destination: FindUsernamePhoneVerifyView(viewModel: viewModel).modifier(HideNavigationBar()),
                isActive: $navigateToNextStep
            ) {
                EmptyView()
            }
            
            ActionButton(text: "Send code", isLoading: $viewModel.isSendingCodeToEmail, isDisabled: $diableNextButton) {
                isEmailInputBoxFocused = false
                viewModel.showEmailVerification = true
            }
            .padding(.bottom, UIScreen.screenHeight * 0.02)
        }
        .padding(.horizontal, UIScreen.screenWidth * 0.043)
    }
    
    func stepInfo() -> some View {
        VStack {
            HStack {
                Text("Step 1 of 2")
                    .font(Font.custom("SFProText-Medium", size: FontSize.callout))
                Text("Verify email address")
                    .font(Font.custom("SFProText-Regular", size: FontSize.callout))
                Spacer()
            }
            ProgressView(value: 1, total: 2)
                .progressViewStyle(LinearProgressViewStyle(tint: Color("#db0011")))
        }
    }
    
    func emailInput() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Enter email address")
                .font(Font.custom("SFProText-Regular", size: FontSize.label))
            InputTextField(inputText: $viewModel.email, isFocused: _isEmailInputBoxFocused) { inputEmail in
                diableNextButton = !inputEmail.isEmail
            }
        }
    }
    
    func verificationContent() -> some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            ClosableView {
                OTPVerification(
                    contactInfo: ContactInfo(value: Contact.email(viewModel.email)),
                    email: viewModel.email,
                    sendCaptcha: sendCaptcha,
                    onCaptchaReady: handleCaptcha,
                    verifyCaptchaErrorMessage: $viewModel.apiErrorMessageForEmailVerification
                )
                .padding(.horizontal, UIScreen.screenWidth * 0.043)
                .padding(.top, UIScreen.screenHeight * 0.084)
            } onCloseClick: {
                viewModel.showEmailVerification = false
            }
        }
    }
    
    private func sendCaptcha() async {
        await viewModel.checkEmailAddressAndSendCaptchaToEmail(viewModel.email)
    }
    
    private func handleCaptcha(captcha: String) async throws -> Bool {
        if !navigateToNextStep {
            navigateToNextStep = await viewModel.verifyEmailCaptcha(viewModel.email, captcha)
        }
        return navigateToNextStep
    }

}
struct FindUsernameEmailVeirfyView_Previews: PreviewProvider {
    static var previews: some View {
        FindUsernameEmailVeirfyView()
    }
}
