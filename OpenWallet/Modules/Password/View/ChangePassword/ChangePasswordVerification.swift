//
//  ChangePasswordVerification.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/9/22.
//

import SwiftUI

struct ChangePasswordVerification: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: PasswordViewModel
    @State var verificationScenario: VerificationScenario = VerificationScenario.byPhone
    @State var captchaScenario: CaptchaScenarioEnum = .changePassword
    @State var countryCode: String = ""
    @State var phoneNumber: String = ""
    
    @State var email: String = ""
    
    @State private var showVerification: Bool = false
    @State private var navigateToEnterNewPasswordStep: Bool = false
    
    @State private var disableChangePasswordViaPhone: Bool = true
    @State private var disableChangePasswordViaEmail: Bool = true
    @FocusState private var isEmailInputFocused: Bool
    @FocusState private var isPhoneInputFocused: Bool
    
    @Binding var showChangePasswordView: Bool

    var body: some View {
        mainContent()
            .overlay {
                if showVerification {
                    verificationContent()
                }
            }
    }
}

extension ChangePasswordVerification {
    func mainContent() -> some View {
        VStack {
            TopBarView(title: "Change password", backAction: {dismiss()})
                .overlay(alignment: .trailing) {
                    Button {
                        showChangePasswordView = false
                    } label: {
                        Text("Cancel")
                            .font(Font.custom("SFProText-Regular", size: FontSize.body))
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom, UIScreen.screenHeight * 0.015)
            
            stepInfo()
                .padding(.bottom, UIScreen.screenHeight * 0.03)
            
            inputSection()
            
            Spacer()

            buttonGroup()
                .padding(.bottom, UIScreen.screenHeight * 0.02)
        }
        .padding(.horizontal, UIScreen.screenWidth * 0.043)
    }
    
    func verificationContent() -> some View {
        ZStack {
            NavigationLink(
                destination: EnterNewPasswordView(
                    viewModel: viewModel,
                    scenario: ChangePasswordScenario.changePassword,
                    navigateToWorkflowRoot: .constant(true),
                    showChangePasswordView: $showChangePasswordView
                ).modifier(HideNavigationBar()),
                isActive: $navigateToEnterNewPasswordStep
            ) {
                EmptyView()
            }.isDetailLink(false)
            
            Color.white.ignoresSafeArea()
            
            ClosableView {
                VStack(alignment: .center) {
                    OTPVerification(
                        contactInfo: getContactInfo(),
                        email: User.shared.email,
                        sendCaptchaRightAway: true,
                        sendCaptcha: sendCaptcha,
                        onCaptchaReady: handleCaptcha,
                        verifyCaptchaErrorMessage: $viewModel.apiErrorMessage
                    )
                    Spacer()
                }
                .padding(.top, UIScreen.screenHeight * 0.084)
                .padding(.horizontal, UIScreen.screenWidth * 0.043)
            } onCloseClick: {
                showVerification = false
                viewModel.apiErrorMessage = ""
            }
        }
    }

    func stepInfo() -> some View {
        VStack {
            HStack {
                Text("Step 2 of 3")
                    .font(Font.custom("SFProText-Medium", size: FontSize.callout))
                Text(getStepMessage())
                    .font(Font.custom("SFProText-Regular", size: FontSize.callout))
                Spacer()
            }
            ProgressView(value: 2, total: 3)
                .progressViewStyle(LinearProgressViewStyle(tint: Color("#db0011")))
        }
    }
    
    func inputSection() -> some View {
        Group {
            switch verificationScenario {
            case VerificationScenario.byEmail:
                emailInput()
            case VerificationScenario.byPhone:
                PhoneNumberInput(countryCode: $countryCode, phoneNumber: $phoneNumber)
                    .focused($isPhoneInputFocused)
                    .onChange(of: countryCode) { _ in
                        disableChangePasswordViaPhone = countryCode.isEmpty || !phoneNumber.isValidPhoneNumber
                    }
                    .onChange(of: phoneNumber) { _ in
                        disableChangePasswordViaPhone = countryCode.isEmpty || !phoneNumber.isValidPhoneNumber
                    }
            }
        }
    }
    
    func emailInput() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Enter email")
                .font(Font.custom("SFProText-Regular", size: FontSize.label))
            InputTextField(inputText: $email, isFocused: _isEmailInputFocused) { inputEmail in
                disableChangePasswordViaEmail = !inputEmail.isEmail
            }
        }
    }
    
    func buttonGroup() -> some View {
        Group {
            switch verificationScenario {
            case VerificationScenario.byEmail:
                buttonGroupForEmailScenario()
            case VerificationScenario.byPhone:
                buttonGroupForPhoneScenario()
            }
        }
    }
    
    func buttonGroupForPhoneScenario() -> some View {
        VStack(spacing: UIScreen.screenHeight * 0.009) {
            ActionButton(
                text: "Change password via phone number",
                isPrimaryButton: true,
                isDisabled: $disableChangePasswordViaPhone
            ) {
                showVerification = true
                isPhoneInputFocused = false
            }
            ActionButton(text: "Change password via email", isPrimaryButton: false) {
                // reset phone number input
                countryCode = ""
                phoneNumber = ""
                
                verificationScenario = VerificationScenario.byEmail
            }
        }
    }

    func buttonGroupForEmailScenario() -> some View {
        VStack(spacing: UIScreen.screenHeight * 0.009) {
            ActionButton(
                text: "Change password via email",
                isPrimaryButton: true,
                isDisabled: $disableChangePasswordViaEmail
            ) {
                showVerification = true
                isEmailInputFocused = false
            }
            ActionButton(text: "Change password via phone number", isPrimaryButton: false) {
                // reset email input
                email = ""
                
                verificationScenario = VerificationScenario.byPhone
            }
        }
    }
    
    func getStepMessage() -> String {
        switch verificationScenario {
        case VerificationScenario.byEmail:
            return "Verify email"
        case VerificationScenario.byPhone:
            return "Verify phone number"
        }
    }

    private func sendCaptcha() async {
        switch verificationScenario {
        case VerificationScenario.byEmail:
            await viewModel.sendEmailCaptcha(email, captchaScenario: captchaScenario)
        case VerificationScenario.byPhone:
            await viewModel.sendSMSCaptcha(phoneNumber, countryCode, captchaScenario: captchaScenario)
        }

    }
    
    private func handleCaptcha(captcha: String) async throws -> Bool {
        // handle the captcha here
        if !navigateToEnterNewPasswordStep {
            switch verificationScenario {
            case VerificationScenario.byEmail:
                navigateToEnterNewPasswordStep = try await viewModel.verifyEmailCaptcha(email, captcha, captchaScenario: captchaScenario)
            case VerificationScenario.byPhone:
                navigateToEnterNewPasswordStep = await viewModel.verifyPhoneCaptcha(phoneNumber, countryCode, captcha, captchaScenario: captchaScenario)
            }
        }
        return navigateToEnterNewPasswordStep
    }
    
    private func getContactInfo() -> ContactInfo {
        switch verificationScenario {
        case .byEmail:
            return ContactInfo(value: Contact.email(email))
        case .byPhone:
            return ContactInfo(value: Contact.phoneNumber(PhoneNumber(areaCode: countryCode, number: phoneNumber)))
        }
    }
}

struct ChangePasswordVerification_Previews: PreviewProvider {
    @State static var viewModel: PasswordViewModel = PasswordViewModel()
    @State static var scenario = VerificationScenario.byEmail
    
    static var previews: some View {
        ChangePasswordVerification(viewModel: viewModel, verificationScenario: VerificationScenario.byPhone, showChangePasswordView: .constant(false))
        ChangePasswordVerification(viewModel: viewModel, verificationScenario: VerificationScenario.byEmail, showChangePasswordView: .constant(false))
    }
}
