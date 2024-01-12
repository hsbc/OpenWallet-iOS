//
//  SelectVerification.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/13.
//

import SwiftUI

struct SelectVerification: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: LogonViewModel

    @State var navigateToHome: Bool = false
    @State var senario: VerificationScenario = VerificationScenario.byPhone
    
    @State private var showCaptchaVerification: Bool = false
    @State private var verifyCaptchaErrorMessage: String = ""

    var body: some View {
        VStack {
            TopBarView(title: "Select verification method", backAction: {dismiss()})
                .padding(.top, UIScreen.screenHeight * 0.012)
                .padding(.bottom, UIScreen.screenHeight * 0.039)
            
            verificationMethodTabs()
            
            navigationLinks()
            
            Spacer()
        }
        .viewAppearLogger(self)
        .padding(.horizontal, UIScreen.screenWidth * 0.043)
        .overlay(alignment: .bottom) {
            termsAndConditionsNote()
                .padding(.bottom, UIScreen.screenHeight * 0.01)
        }
        .overlay {
            if showCaptchaVerification {
                verificationContent()
                    .overlay(alignment: .top) {
                        ToastNotification(showToast: $viewModel.showSendCaptchaWarning, message: $viewModel.sendCaptchaErrorMessage)
                            .padding(.horizontal, UIScreen.screenWidth * 0.021)
                            .padding(.top, UIScreen.screenHeight * 0.064)
                    }
            }
        }
    }

}

extension SelectVerification {
    
    func verificationMethodTabs() -> some View {
        HStack(spacing: UIScreen.screenWidth * 0.024) {
            emailTabContent()
            phoneTabContent()
        }
    }
    
    func emailTabContent() -> some View {
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
                showCaptchaVerification = true
            }
        }
    }
    
    func phoneTabContent() -> some View {
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
                showCaptchaVerification = true
            }
        }
    }

    func verificationContent() -> some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            ClosableView {
                OTPVerification(
                    contactInfo: getContactInfo(),
                    email: viewModel.firstFactorResponse!.maskedEmail,
                    sendCaptcha: getSendCodeFunction(),
                    onCaptchaReady: handleCaptcha,
                    verifyCaptchaErrorMessage: $verifyCaptchaErrorMessage
                )
                .padding(.horizontal, UIScreen.screenWidth * 0.043)
                .padding(.top, UIScreen.screenHeight * 0.084)
            } onCloseClick: {
                showCaptchaVerification = false
                verifyCaptchaErrorMessage = ""
            }
        }
    }
    
    func navigationLinks() -> some View {
        NavigationLink(
            destination: MainView().modifier(HideNavigationBar()),
            isActive: $navigateToHome
        ) {
            EmptyView()
        }
        .accessibilityHidden(true)
    }
    
    private func handleCaptcha(captcha: String) async throws -> Bool {
        do {
            let validateRequest = getValidateRequest(captcha: captcha)
            let result = try await viewModel.captchaService.captchaValidate(request: validateRequest)
            if result.status {
                // if captcha is correct, navigate to Home
                let userProfile: UserProfile = result.data!
                let customerProfile = try await viewModel.customerService.getProfile(userProfile.token)

                try await viewModel.doLoginRequest(signInedUser: userProfile, customerProfile: customerProfile)
                AppState.shared.selectedTab = .home
                navigateToHome.toggle()
            }
            
            verifyCaptchaErrorMessage = result.message
            switch senario {
            case VerificationScenario.byPhone:
                OTPManager.shared.checkSmsVerifyLimit(viewModel.firstFactorResponse!.maskedEmail,
                                                      message: result.message)
            case VerificationScenario.byEmail:
                OTPManager.shared.checkEmailVerifyLimit(viewModel.firstFactorResponse!.maskedEmail,
                                                        message: result.message)
                
            }
            return result.status
        } catch let apiErrorResponse as ApiErrorResponse {
            verifyCaptchaErrorMessage = apiErrorResponse.message ?? AppState.defaultErrorMesssage
            return false
        } catch {
            viewModel.navigateToErrorPage = true
            return false
        }
    }
    
    private func getContactInfo() -> ContactInfo {
        switch senario {
        case VerificationScenario.byPhone:
            return ContactInfo(value: Contact.phoneNumber(PhoneNumber(areaCode: "", number: "")),
                               maskedAddress: viewModel.firstFactorResponse!.maskedPhoneNumber,
                               userName: viewModel.userName,
                               token: viewModel.firstFactorResponse!.maskedPhoneNumber)
        case VerificationScenario.byEmail:
            return ContactInfo(value: Contact.email(viewModel.firstFactorResponse!.maskedEmail),
                               maskedAddress: viewModel.firstFactorResponse!.maskedEmail,
                               userName: viewModel.userName,
                               token: viewModel.firstFactorResponse!.token)
        }
    }
    
    private func getValidateRequest(captcha: String) -> CaptchaValidateRequest {
        switch senario {
        case VerificationScenario.byPhone:
            return CaptchaValidateRequest(username: viewModel.userName,
                                          captcha: captcha,
                                          token: viewModel.firstFactorResponse!.token,
                                          captchaScenarioEnum: CaptchaScenarioEnum.signIn,
                                          captchaTypeEnum: CaptchaTypeEnum.smsVeyrif)
        case VerificationScenario.byEmail:
            return CaptchaValidateRequest(username: viewModel.userName,
                                          captcha: captcha,
                                          token: viewModel.firstFactorResponse!.token,
                                          captchaScenarioEnum: CaptchaScenarioEnum.signIn,
                                          captchaTypeEnum: CaptchaTypeEnum.mailVerify)
        }
    }
    
    private func getSendCodeFunction() -> ( () async -> Void) {
        switch senario {
        case VerificationScenario.byPhone:
            return viewModel.sendCaptchaToPhone
        case VerificationScenario.byEmail:
            return viewModel.sendCaptchaToEmail
        }
    }
    
    func termsAndConditionsNote() -> some View {
        Text("By logging on, you agree to the Terms and Conditions.")
            .foregroundColor(Color("#333333"))
            .font(Font.custom("SFProText-Regular", size: FontSize.caption))
    }

}

struct SelectVerification_Previews: PreviewProvider {
    static private let viewModel = LogonViewModel()
    
    static var previews: some View {
        SelectVerification(viewModel: LogonViewModel())
    }
}
