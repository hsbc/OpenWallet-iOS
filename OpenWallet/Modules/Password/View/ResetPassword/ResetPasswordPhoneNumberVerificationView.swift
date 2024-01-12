//
//  ResetPasswordPhoneNumberVerificationView.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/13/22.
//

import SwiftUI

struct ResetPasswordPhoneNumberVerificationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: PasswordViewModel
    @Binding var navigateToWorkflowRoot: Bool

    @State var captchaScenario: CaptchaScenarioEnum = .resetPassword
    @State var countryCode: String = ""
    @State var phoneNumber: String = ""
    
    @State private var scenario: ChangePasswordScenario = ChangePasswordScenario.forgotPassword
    @State private var diableNextButton: Bool = !User.shared.isLoggin
    @State private var navigateToNextStep: Bool = false
    @FocusState private var isPhoneNumberInputBoxFocused: Bool
    
    @Binding var showChangePasswordView: Bool
    
    var body: some View {
        mainContent()
            .overlay {
                if viewModel.showPhoneCaptchaVerification {
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

extension ResetPasswordPhoneNumberVerificationView {
    func mainContent() -> some View {
        VStack {
            TopBarView(title: viewModel.getBarTitle(scenario), backAction: {
                // A workaround to hide email OTP verification in previous step. [weihao.zhang]
                viewModel.showEmailCaptchaVerification = false

                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    dismiss()
                }
            })
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
                loginStatePhoneInfo()
            } else {
                phoneNumberInput()
            }
            
            Spacer()
            
            ActionButton(text: "Next", isLoading: $viewModel.isSendingCaptcha, isDisabled: $diableNextButton) {
                isPhoneNumberInputBoxFocused = false
                viewModel.showPhoneCaptchaVerification = true
            }
            .padding(.bottom, UIScreen.screenHeight * 0.02)
        }
        .padding(.horizontal, UIScreen.screenWidth * 0.043)
        .onAppear {
            if User.shared.isLoggin {
                countryCode = User.shared.phoneCountryCode
                phoneNumber = User.shared.phoneNumber
            }
        }
        
    }
    
    func stepInfo() -> some View {
        VStack {
            HStack {
                Text("Step 2 of 3")
                    .font(Font.custom("SFProText-Medium", size: FontSize.callout))
                Text("Verify mobile phone number")
                    .font(Font.custom("SFProText-Regular", size: FontSize.callout))
                Spacer()
            }
            ProgressView(value: 2, total: 3)
                .progressViewStyle(LinearProgressViewStyle(tint: Color("#db0011")))
        }
    }
    
    func loginStatePhoneInfo() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Verify the bank account connected email ")
                    .font(Font.custom("SFProText-Regular", size: FontSize.label))
                    .foregroundColor(Color("#333333"))
                Spacer()
            }
            HStack {
                Text(ContactInfo(value: Contact.phoneNumber(PhoneNumber(areaCode: User.shared.phoneCountryCode, number: User.shared.phoneNumber))).getMaskedValue())
                    .font(Font.custom("SFProText-Regular", size: FontSize.body))
                    .foregroundColor(Color("#333333"))
                Spacer()
            }
            
        }
    }
    
    func phoneNumberInput() -> some View {
        PhoneNumberInput(countryCode: $countryCode, phoneNumber: $phoneNumber)
            .onChange(of: countryCode) { _ in
                diableNextButton = countryCode.isEmpty || !phoneNumber.isValidPhoneNumber
            }
            .onChange(of: phoneNumber) { _ in
                diableNextButton = countryCode.isEmpty || !phoneNumber.isValidPhoneNumber
            }
            .focused($isPhoneNumberInputBoxFocused)
    }
    
    func verificationContent() -> some View {
        ZStack {
            NavigationLink(
                destination: EnterNewPasswordView(
                    viewModel: viewModel,
                    scenario: ChangePasswordScenario.forgotPassword,
                    navigateToWorkflowRoot: $navigateToWorkflowRoot,
                    showChangePasswordView: $showChangePasswordView
                ).modifier(HideNavigationBar()),
                isActive: $navigateToNextStep
            ) {
                EmptyView()
            }
            .accessibilityHidden(true)
            
            Color.white.ignoresSafeArea()
            
            ClosableView {
                OTPVerification(
                    contactInfo: ContactInfo(value: Contact.phoneNumber(PhoneNumber(areaCode: countryCode, number: phoneNumber))),
                    email: viewModel.email,
                    sendCaptcha: sendCaptcha,
                    onCaptchaReady: handleCaptcha,
                    verifyCaptchaErrorMessage: $viewModel.apiErrorMessage
                )
                .padding(.horizontal, UIScreen.screenWidth * 0.043)
                .padding(.top, UIScreen.screenHeight * 0.084)
            } onCloseClick: {
                viewModel.showPhoneCaptchaVerification = false
                viewModel.apiErrorMessage = ""
            }
        }
    }
    
    private func sendCaptcha() async {
        await viewModel.sendSMSCaptcha(phoneNumber, countryCode, captchaScenario: captchaScenario)
    }
    
    private func handleCaptcha(captcha: String) async throws -> Bool {
        // handle the captcha here
        if !navigateToNextStep {
            navigateToNextStep = await viewModel.verifyPhoneCaptcha(phoneNumber, countryCode, captcha, captchaScenario: captchaScenario)
        }
        return navigateToNextStep
    }
}

struct ResetPasswordPhoneNumberVerificationView_Previews: PreviewProvider {
    @State static var viewModel: PasswordViewModel = PasswordViewModel()
    
    static var previews: some View {
        ResetPasswordPhoneNumberVerificationView(viewModel: viewModel, navigateToWorkflowRoot: .constant(true), showChangePasswordView: .constant(false))
    }
}
