//
//  RegisterPhone.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/9.
//

import SwiftUI

struct RegisterPhone: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: RegisterViewModel
    @State var isLoading: Bool = false
    @State private var navigateToNextStep: Bool = false
    @FocusState private var isPhoneInputBoxFocused: Bool

    var body: some View {
        ZStack {
            PopUpView(settings: viewModel.popupSettings,
                      show: $viewModel.showPopup) {
                NavigationStateForRegister.shared.registerToRoot = false
            }.zIndex(1)
            VStack {
                NavigationLink(
                    destination:
                        RegisterTermsAndConditions(viewModel: viewModel).modifier(HideNavigationBar()),
                    isActive: $navigateToNextStep
                ) {}.id(viewModel.backToEmailRegister)

                TopBarView(title: "Register", backAction: {
                    // A workaround to hide email OTP verification in previous step. [weihao.zhang]
                    viewModel.showEmailOTPVerification = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        viewModel.backToEmailRegister.toggle()
                    }
                })
                .overlay(alignment: .trailing) {
                    Button {
                        NavigationStateForRegister.shared.registerToRoot = false
                    } label: {
                        Text("Cancel")
                            .font(Font.custom("SFProText-Regular", size: FontSize.body))
                            .foregroundColor(.black)
                    }
                }
                .padding(.top, UIScreen.screenHeight*0.0136)
                
                VStack(alignment: .leading) {
                    ProgressBar(step: 4)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Please enter the mobile phone number connected to your bank account.")
                            .font(Font.custom("SFProText-Regular", size: FontSize.body))
                            .padding(.top, UIScreen.screenHeight*0.03)
                        PhoneNumberInput(countryCode: $viewModel.countryCode, phoneNumber: $viewModel.phoneNum)
                            .padding(.top, UIScreen.screenHeight*0.03)
                            .focused($isPhoneInputBoxFocused)
                    }
                    
                    Spacer()
                    
                    ActionButton(text: "Submit", isLoading: $isLoading) {
                        isLoading = true
                        Task {
                            if viewModel.phoneNum.count > 0 {
                                isLoading = false
                                viewModel.showSMSOTPVerification = true
                            } else {
                                isLoading = false
                               return
                            }
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
            .viewAppearLogger(self)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }.padding(.horizontal, PaddingConstant.widthPadding16)
        .onDisappear {
            viewModel.showRegisterApiErrorMessage = false
        }
        .overlay {
            if viewModel.showSMSOTPVerification {
                verificationContent()
            }
        }

    }
    
    func verificationContent() -> some View {
        ZStack {
            Color.white.ignoresSafeArea()
            ClosableView {
                PopUpView(
                    settings: viewModel.popupSettings,
                    show: $viewModel.showPopupAtVerifyView
                ) {}.zIndex(1)

                OTPVerification(
                    contactInfo: ContactInfo(value: Contact.phoneNumber(PhoneNumber(areaCode: viewModel.countryCode, number: viewModel.phoneNum))),
                    email: viewModel.email,
                    sendCaptcha: sendCaptcha,
                    onCaptchaReady: handleCaptcha,
                    verifyCaptchaErrorMessage: $viewModel.registerFlowApiErrorMessage
                )
                .padding(.horizontal, PaddingConstant.widthPadding16)
                .padding(.top, UIScreen.screenHeight * 0.084)
            } onCloseClick: {
                viewModel.showRegisterApiErrorMessage = false
                viewModel.registerFlowApiErrorMessage = ""
                viewModel.showSMSOTPVerification = false
            }
        }
    }

}

extension RegisterPhone {
    
    private func sendCaptcha() async {
        _ = await viewModel.sendCaptchaToPhone()
    }
    
    private func handleCaptcha(captcha: String) async throws -> Bool {
        if !navigateToNextStep {
            navigateToNextStep = await viewModel.validatePhoneCaptcha(captcha)
        }
        return navigateToNextStep
    }

}

struct RegisterPhone_Previews: PreviewProvider {
    static var previews: some View {
        RegisterPhone(viewModel: RegisterViewModel())
    }
}
