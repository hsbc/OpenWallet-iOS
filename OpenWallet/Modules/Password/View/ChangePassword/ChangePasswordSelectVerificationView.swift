//
//  ChangePasswordSelectVerificationView.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/10/11.
//

import SwiftUI

struct ChangePasswordSelectVerificationView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: PasswordViewModel
    
    @Binding var navigateToWorkflowRoot: Bool

    @State var senario: VerificationScenario = VerificationScenario.byPhone
    @State var captchaScenario: CaptchaScenarioEnum = .changePassword
    @State private var verifyCaptchaErrorMessage: String = ""
    @State private var navigateToEnterNewPasswordStep: Bool = false
    
    @Binding var showChangePasswordView: Bool

    var body: some View {
        VStack {
            TopBarView(title: "Change password", backAction: { dismiss() })
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
                .padding(.bottom, UIScreen.screenHeight * 0.034)
           
            verificationMethodTabs()

            Spacer()
        }
        .padding(.horizontal, UIScreen.screenWidth * 0.043)
        .overlay {
            if viewModel.showEmailCaptchaVerification || viewModel.showPhoneCaptchaVerification {
                verificationContent()
                    .overlay {
                        ToastNotification(showToast: $viewModel.showCommonErrorToast, message: $viewModel.toastErrorMessage)
                            .padding(.horizontal, UIScreen.screenWidth * 0.021)
                            .padding(.top, UIScreen.screenHeight * 0.064)
                    }
            }
        }
    }
}

extension ChangePasswordSelectVerificationView {
    
    func stepInfo() -> some View {
        VStack {
            HStack {
                Text("Step 2 of 3")
                    .font(Font.custom("SFProText-Medium", size: FontSize.callout))
                Text("Select verification method")
                    .font(Font.custom("SFProText-Regular", size: FontSize.callout))
                Spacer()
            }
            ProgressView(value: 2, total: 3)
                .progressViewStyle(LinearProgressViewStyle(tint: Color("#db0011")))
        }
    }
    
    private func commonErrorToastContent() -> some View {
        ToastNotification(showToast: .constant(true), message: .constant("Sorry, something is wrong. Please try again."))
            .onAppear {
                // Dismiss launch after after certain duration time
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    viewModel.showCommonErrorToast = false
                }
            }
    }

    func verificationMethodTabs() -> some View {
        HStack(spacing: UIScreen.screenWidth * 0.024) {
            VStack(alignment: .leading) {
                Image("Email")
                    .resizable()
                    .scaledToFit()
                    .frame(height: UIScreen.screenHeight * 0.044)
                    .padding(.top)

                Text("Verify by email")
                    .font(Font.custom("SFProText-Regular", size: FontSize.label))
                    .frame(width: UIScreen.screenWidth * 0.381, alignment: .leading)
                    .foregroundColor(.black)
            }
            .padding(.horizontal, UIScreen.screenWidth * 0.032)
            .frame(width: UIScreen.screenWidth * 0.445, height: UIScreen.screenHeight * 0.138, alignment: .topLeading)
            .background(Color.white.shadow(radius: 1))
            .onTapGesture {
                Task { @MainActor in
                    senario = VerificationScenario.byEmail
                    viewModel.showEmailCaptchaVerification = true
                }
            }

            VStack(alignment: .leading) {
                Image("phone")
                    .resizable()
                    .scaledToFit()
                    .frame(height: UIScreen.screenHeight * 0.044)
                    .padding(.top)

                Text("Verify by mobile phone number")
                    .font(Font.custom("SFProText-Regular", size: FontSize.label))
                    .frame(width: UIScreen.screenWidth * 0.381, alignment: .leading)
                    .foregroundColor(.black)
            }
            .padding(.horizontal, UIScreen.screenWidth * 0.032)
            .frame(width: UIScreen.screenWidth * 0.445, height: UIScreen.screenHeight * 0.138, alignment: .topLeading)
            .background(Color.white.shadow(radius: 1))
            .onTapGesture {
                Task { @MainActor in
                    senario = VerificationScenario.byPhone
                    viewModel.showPhoneCaptchaVerification = true
                }
            }
        }
    }
    
    func verificationContent() -> some View {
        ZStack {
            navigationLinks()

            Color.white.ignoresSafeArea()
            
            ClosableView {
                OTPVerification(
                    contactInfo: getContactInfo(),
                    email: User.shared.email,
                    sendCaptcha: sendCaptcha,
                    onCaptchaReady: handleCaptcha,
                    verifyCaptchaErrorMessage: $viewModel.apiErrorMessage
                )
                .padding(.horizontal, UIScreen.screenWidth * 0.043)
                .padding(.top, UIScreen.screenHeight * 0.084)
            } onCloseClick: {
                switch senario {
                case VerificationScenario.byPhone:
                    viewModel.showPhoneCaptchaVerification = false
                case VerificationScenario.byEmail:
                    viewModel.showEmailCaptchaVerification = false
                }
                viewModel.apiErrorMessage = ""
            }
        }
    }
    
    func navigationLinks() -> some View {
        NavigationLink(
            destination: EnterNewPasswordView(
                viewModel: viewModel,
                scenario: ChangePasswordScenario.changePassword,
                navigateToWorkflowRoot: $navigateToWorkflowRoot,
                showChangePasswordView: $showChangePasswordView
            ).modifier(HideNavigationBar()),
            isActive: $navigateToEnterNewPasswordStep
        ) {
            EmptyView()
        }
    }
    
    private func handleCaptcha(captcha: String) async throws -> Bool {
        if !navigateToEnterNewPasswordStep {
            switch senario {
            case .byEmail:
                navigateToEnterNewPasswordStep = try await viewModel.verifyEmailCaptcha(User.shared.email, captcha, captchaScenario: captchaScenario)
            case .byPhone:
                navigateToEnterNewPasswordStep = await viewModel.verifyPhoneCaptcha(User.shared.phoneNumber, User.shared.phoneCountryCode, captcha, captchaScenario: captchaScenario)
            }
        }
        return navigateToEnterNewPasswordStep
        
    }
    
    private func getContactInfo() -> ContactInfo {
        switch senario {
        case .byPhone:
            return ContactInfo(value: Contact.phoneNumber(PhoneNumber(areaCode: User.shared.phoneCountryCode, number: User.shared.phoneNumber)))
        case .byEmail:
            return ContactInfo(value: Contact.email(User.shared.email))
        }
    }
    
    private func sendCaptcha() async {
        switch senario {
        case VerificationScenario.byPhone:
            await viewModel.sendSMSCaptcha(User.shared.phoneNumber, User.shared.phoneCountryCode, captchaScenario: captchaScenario)
        case VerificationScenario.byEmail:
            await viewModel.sendEmailCaptcha(User.shared.email, captchaScenario: captchaScenario)
        }
    }

}

struct ChangePasswordSelectVerificationView_Previews: PreviewProvider {
    static private let viewModel = PasswordViewModel()
    
    static var previews: some View {
        ChangePasswordSelectVerificationView(viewModel: viewModel, navigateToWorkflowRoot: .constant(false), showChangePasswordView: .constant(false))
    }
}
