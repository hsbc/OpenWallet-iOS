//
//  RegisterEmail.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/9.
//

import SwiftUI

struct RegisterEmail: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: RegisterViewModel
    @State var isLoading: Bool = false
    @State private var diableNextButton: Bool = true
    @State private var navigateToNextStep: Bool = false
    @FocusState private var isEmailInputBoxFocused: Bool
    
    var body: some View {
        ZStack {
            PopUpView(settings: viewModel.popupSettings, show: $viewModel.showPopup) {
                NavigationStateForRegister.shared.registerToRoot = false
            }.zIndex(1)
            VStack {
                NavigationLink(
                    destination:
                        RegisterPhone(viewModel: viewModel).modifier(HideNavigationBar()),
                    isActive: $navigateToNextStep
                ) {}.id(viewModel.backToEmailRegister)
                
                TopBarView(title: "Register", backAction: {dismiss()})
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
                    ProgressBar(step: 3)
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Please enter the email address connected to your bank account.")
                            .font(Font.custom("SFProText-Regular", size: FontSize.body))
                            .padding(.top, UIScreen.screenHeight*0.03)
                        InputTextField(label: "Enter email address", inputText: $viewModel.email, isErrorState: $viewModel.showEmailNotAcceptableError, isFocused: _isEmailInputBoxFocused, onTextChange: { newValue in
                            diableNextButton = !newValue.isEmail
                            viewModel.showEmailNotAcceptableError = false
                        })
                        .padding(.top, UIScreen.screenHeight*0.0299)

                        if viewModel.showEmailNotAcceptableError {
                            HStack {
                                Image("Warning on light")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                    .foregroundColor(Color("#a8000b"))
                                
                                Text(viewModel.otherEmailAddressErrrorMessage ?? viewModel.notAcceptatbleEmailAddressErrorMessage)
                                    .font(Font.custom("SFProText-Regular", size: FontSize.warning))
                                
                                Spacer()
                            }
                            .padding(.vertical, 12)
                        }
                    }
                    
                    Spacer()
                    
                    ActionButton(text: "Send Code", isLoading: $isLoading, isDisabled: $diableNextButton) {
                        isLoading = true
                        isEmailInputBoxFocused = false
                        Task {
                            let isEmailWithCorrectFormat = await viewModel.isEmailWithCorrectFormat()
                            if !isEmailWithCorrectFormat {
                                viewModel.showEmailNotAcceptableError = true
                                isLoading = false
                                return
                            } else {
                                viewModel.showEmailOTPVerification = true
                                isLoading = false
                            }
                        }
                    }
                    .padding(.bottom, PaddingConstant.heightPadding16)
                    
                }
            }
            .padding(.horizontal, PaddingConstant.widthPadding16)
            .overlay {
                if viewModel.showEmailOTPVerification {
                    verificationContent()
                        .onDisappear {
                            viewModel.registerFlowApiErrorMessage = ""
                        }
                }
            }
            .viewAppearLogger(self)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }.onAppear {
            OTPManager.shared.resetSmsVerifyLimit(viewModel.username)
            OTPManager.shared.resetEmailVerifyLimit(viewModel.username)
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
                    contactInfo: ContactInfo(value: Contact.email(viewModel.email)),
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
                viewModel.showEmailOTPVerification = false
            }
        }
    }
    
}
extension RegisterEmail {
    
    private func sendCaptcha() async {
        _ = await viewModel.sendCaptchaToEmail()
    }
    
    private func handleCaptcha(captcha: String) async throws -> Bool {
        if !navigateToNextStep {
            navigateToNextStep = await viewModel.validateEmailCaptcha(viewModel.email, captcha)
        }
        return navigateToNextStep
    }
    
}

struct RegisterEmail_Previews: PreviewProvider {
    static var previews: some View {
        RegisterEmail(viewModel: RegisterViewModel())
    }
}
