//
//  EmailVerificationView.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/6/22.
//

import SwiftUI

/**
 @Summary
  A reusable component for email address verification with captcha
 */
struct EmailVerificationView: View {
    var email: String
    @Binding var isEmailVerified: Bool
    
    var captcha: Binding<String>?
    var isCaptchaReady: Binding<Bool>?
    
    var sendCaptcha: (_ email: String) async throws -> Bool
    var verifyCaptcha: ((_ email: String, _ captcha: String) async throws -> Bool)?
    var onCaptchaVerified: ((_ isVerified: Bool) -> Void)?
    
    var bypassCaptchaVerification: Bool = false
    var sendCaptchaRightAway: Bool = true // set it to false if do not want to send captcha right away
    @State var resendCaptchaCoolOffTime: Double = 300
    var desiredCaptchaLength: Int = 6

    @State private var _captcha: String = ""
    @State private var isCaptchaSent: Bool = false
    @State private var hasTriedSendingCaptcha: Bool = false
    @State private var errorMessage: String = ""
    
    @State private var isVerificationFailed: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Please enter the 6-digit verification code. We have sent it to")
                    .font(Font.custom("SFProText-Light", size: FontSize.label))
                Text(email)
                    .font(Font.custom("SFProDisplay-Regular", size: FontSize.title1))
            }
            .padding(.bottom, 24)
            
            VStack(spacing: 4) {
                HStack {
                    Text("Verification code")
                        .font(Font.custom("SFProText-Regular", size: FontSize.label))

                    Spacer()
                    
                    if hasTriedSendingCaptcha {
                        CountdownTimer(
                            timeRemaining: $resendCaptchaCoolOffTime,
                            timeIsUp: {
                                hasTriedSendingCaptcha = false
                            }
                        )
                    } else {
                        Button {
                            hasTriedSendingCaptcha = true
                            Task {
                                await sendCaptcha()
                            }
                        } label: {
                            Text("Send code")
                                .font(Font.custom("SFProText-Regular", size: FontSize.caption))
                                .foregroundColor(email.isEmpty ? .gray : Color("#14a5ab"))
                        }
                        .disabled(email.isEmpty)
                    }
                }
                
                InputTextField(inputText: $_captcha, isErrorState: $isVerificationFailed, onTextChange: { newValue in
                    isVerificationFailed = false
                    errorMessage = ""
                    captcha?.wrappedValue = newValue
                    
                    guard isReadyForCodeValidation(newValue) else { return }
                    isCaptchaReady?.wrappedValue = true
                    
                    guard !bypassCaptchaVerification else { return }
                    
                    Task {
                        do {
                            if verifyCaptcha != nil {
                                isEmailVerified = try await verifyCaptcha!(email, _captcha)
                            }
                            
                            if onCaptchaVerified != nil {
                                onCaptchaVerified!(isEmailVerified)
                            }
                        } catch {
                            isVerificationFailed = true
                            errorMessage = "Failed to validate email and captcha."
                        }
                    }
                })
                .padding(.top, 4)
                
                if !errorMessage.isEmpty {
                    HStack {
                        Image("Error on light")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width*0.053)
                            .foregroundColor(Color("#a8000b"))
                        
                        Text("Invalid code.").font(Font.custom("SFProText-Regular", size: FontSize.warning))

                        Spacer()
                    }
                    .padding(.top, 12)
                } 
            }
        }
        .task {
            guard sendCaptchaRightAway && !hasTriedSendingCaptcha else { return }
            await sendCaptcha()
        }
    }
}

extension EmailVerificationView {
    private func isReadyForCodeValidation(_ code: String) -> Bool {
        return code.count == desiredCaptchaLength
    }
    
    private func sendCaptcha() async {
        do {
            hasTriedSendingCaptcha = true
            isCaptchaSent = try await sendCaptcha(email)
            errorMessage = ""
        } catch {
            isCaptchaSent = false
            errorMessage = "Failed to send verification code."
        }
    }
}

struct EmailVerificationView_Previews: PreviewProvider {
    static private let email = "Test@OpenWallet.com"
    
    static func sendCode(_ email: String) async -> Bool {
        return true
    }
    
    static func verifyCode(_ email: String, _ captcha: String) async -> Bool {
        return true
    }
    
    @State static var isVerified: Bool = false
    
    @State static var captcha: String = ""
    @State static var isCaptchaReady: Bool = false

    static var previews: some View {
        VStack {
            EmailVerificationView(
                email: email,
                isEmailVerified: $isVerified,
                captcha: $captcha,
                isCaptchaReady: $isCaptchaReady,
                sendCaptcha: sendCode,
                verifyCaptcha: verifyCode
            )
        }
        .padding([.leading, .trailing], 16)
    }
}
