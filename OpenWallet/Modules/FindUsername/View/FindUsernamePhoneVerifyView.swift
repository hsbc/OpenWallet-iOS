//
//  FindUsernamePhoneVerifyView.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/21.
//

import SwiftUI

struct FindUsernamePhoneVerifyView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: FindUsernameViewModel
    
    @State var countryCode: String = ""
    @State var phoneNumber: String = ""
    
    @State private var diableNextButton: Bool = true
    @State private var navigateToNextStep: Bool = false
    @FocusState private var isPhoneNumberInputBoxFocused: Bool
    
    var body: some View {
        mainContent()
            .overlay {
                if viewModel.showPhoneVerification {
                    verificationContent()
                        .onDisappear {
                            viewModel.apiErrorMessageForPhoneVerification = ""
                        }
                }
            }
            .viewAppearLogger(self)
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

extension FindUsernamePhoneVerifyView {
    func mainContent() -> some View {
        VStack {
            TopBarView(title: "Find my username", backAction: {
                // A workaround to hide email OTP verification in previous step. [weihao.zhang]
                viewModel.showEmailVerification = false
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    dismiss()
                }
            })
            .overlay(alignment: .trailing) {
                NavigationLink {
                    WelcomeView()
                        .modifier(HideNavigationBar())
                } label: {
                    Text("Cancel")
                        .font(Font.custom("SFProText-Regular", size: FontSize.body))
                        .foregroundColor(.black)
                }
            }
            .padding(.bottom, UIScreen.screenHeight * 0.015)

            stepInfo()
                .padding(.bottom, UIScreen.screenHeight * 0.03)
            
            PhoneNumberInput(countryCode: $countryCode, phoneNumber: $phoneNumber)
                .onChange(of: countryCode) { _ in
                    diableNextButton = countryCode.isEmpty || !phoneNumber.isValidPhoneNumber
                }
                .onChange(of: phoneNumber) { _ in
                    diableNextButton = countryCode.isEmpty || !phoneNumber.isValidPhoneNumber
                }
                .focused($isPhoneNumberInputBoxFocused)
            
            Spacer()
            
            ActionButton(text: "Send code", isLoading: $viewModel.isSendingCodeToPhone, isDisabled: $diableNextButton) {
                isPhoneNumberInputBoxFocused = false
                viewModel.showPhoneVerification = true
            }
            .padding(.bottom, UIScreen.screenHeight * 0.02)
        }
        .padding(.horizontal, UIScreen.screenWidth * 0.043)
    }
    
    func stepInfo() -> some View {
        VStack {
            HStack {
                Text("Step 2 of 2")
                    .font(Font.custom("SFProText-Medium", size: FontSize.callout))
                Text("Verify mobile phone number")
                    .font(Font.custom("SFProText-Regular", size: FontSize.callout))
                Spacer()
            }
            ProgressView(value: 2, total: 2)
                .progressViewStyle(LinearProgressViewStyle(tint: Color("#db0011")))
        }
    }
    
    func verificationContent() -> some View {
        ZStack {
            NavigationLink(
                destination: SuccessView(detailInfo: "You have successfully found your username.",
                                         buttonText: "Log on",
                                         subTitleText: "Username", subInfoText: viewModel.username, buttonActionAsync: {
                                             
                                         }, destination: {
                                             LogonView(foundedUserName: viewModel.username).modifier(HideNavigationBar())
                                         }).modifier(HideNavigationBar()),
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
                    verifyCaptchaErrorMessage: $viewModel.apiErrorMessageForPhoneVerification
                )
                .padding(.horizontal, UIScreen.screenWidth * 0.043)
                .padding(.top, UIScreen.screenHeight * 0.084)
            } onCloseClick: {
                viewModel.showPhoneVerification = false
            }
        }
    }
    
    private func sendCaptcha() async {
        await viewModel.sendPhoneCaptcha(phoneNumber, countryCode)
    }
    
    private func handleCaptcha(captcha: String) async throws -> Bool {
        if !navigateToNextStep {
            navigateToNextStep = await viewModel.verifyPhoneCaptchaAndGetUarname(phoneNumber, countryCode, captcha)
        }
        return navigateToNextStep
    }

}

struct FindUsernamePhoneVerifyView_Previews: PreviewProvider {
    @State static var viewModel = FindUsernameViewModel()
    
    static var previews: some View {
        FindUsernamePhoneVerifyView(viewModel: viewModel)
    }
}
