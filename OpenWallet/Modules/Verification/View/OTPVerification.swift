//
//  OTPVerification.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/9/22.
//

import SwiftUI

/**
 @Summary
  A reusable component for OTP verification with captcha
 */
struct OTPVerification: View {
    @ObservedObject var otpManager = OTPManager.shared

    var contactInfo: ContactInfo
    var email: String

    var message: String = ""
    var sendCaptchaRightAway: Bool = true // set it to false if do not want to send captcha right away
    var desiredCaptchaLength: Int = 6

    var sendCaptcha: () async  -> Void
    var onCaptchaReady: (_ captcha: String) async throws -> Bool

    @State var verifyCaptchaErrorMessage: Binding<String>?

    @State var isSendingCaptcha: Bool = false
    @State var isCoolingOff: Bool = false
    @State private var captcha: String = ""
    @State private var isVerifying: Bool = false
    @State private var errorMessage: String = ""
    @State private var isCaptchaVerified: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            messageSection()
                .padding(.bottom, UIScreen.screenHeight * 0.02)

            VStack(spacing: 4) {
                countDownTimer()
                captchaSection()
            }

            errorSection()
                .padding(.top, UIScreen.screenHeight * 0.015)
        }
        .overlay {
            if isVerifying {
                VStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                }
                .padding(.bottom, -50)
            }
        }
        .task {
            isCoolingOff = checkIfIsCoolingOff()

            guard sendCaptchaRightAway && !isCoolingOff else { return }
            await handleSendCaptcha()
        }
        .onAppear {
            errorMessage = verifyCaptchaErrorMessage?.wrappedValue ?? ""
            otpManager.resetSmsVerifyLimit(email)
            otpManager.resetEmailVerifyLimit(email)
        }
        .onDisappear {
            if !isCaptchaVerified {
                logOTPDismissDateTime()
            }
        }
        .viewAppearLogger(self)
    }
    
}

extension OTPVerification {
    private func messageSection() -> some View {
        VStack(alignment: .leading, spacing: UIScreen.screenHeight * 0.01) {
            Text(getMessage())
                .font(Font.custom("SFProText-Regular", size: FontSize.body))
            Text(contactInfo.getMaskedValue())
                .font(Font.custom("SFProDisplay-Medium", size: FontSize.title4))
        }
    }
    
    private func countDownTimer() -> some View {
        HStack {
            Spacer()

            if isSendingCaptcha {
                ProgressView()
            } else if isCoolingOff {
                CountdownTimer(
                    timeRemaining: contactInfo.type == .phoneNumber ? $otpManager.smsOTPCoolOffTime : $otpManager.emailOTPCoolOffTime,
                    timeIsUp: {
                        isCoolingOff = false
                    }
                )
            } else {
                Button {
                    Task {
                        await handleSendCaptcha()
                    }
                } label: {
                    Text("Resend code")
                        .font(Font.custom("SFProText-Medium", size: FontSize.button))
                        .foregroundColor(contactInfo.stringifiedValue.isEmpty ? .gray : Color("#db0011"))
                }
                .disabled(contactInfo.stringifiedValue.isEmpty)
            }
        }
    }

    private func captchaSection() -> some View {
        PasscodeField(pin: $captcha,
                      disableInput: (contactInfo.type == .phoneNumber ? $otpManager.smsVerifyLimit : $otpManager.emailVerifyLimit)) { newCaptchaValue in
            guard isReadyForCaptchaValidation(newCaptchaValue) && !isVerifying else { return }

            Task {
                isVerifying = true
                isCaptchaVerified = try await onCaptchaReady(captcha)

                if isCaptchaVerified {
                    clearCoolOffTime()
                    resetOTPDismissDateTime()
                } else {
                    errorMessage = verifyCaptchaErrorMessage?.wrappedValue ?? AppState.defaultErrorMesssage
                    captcha = ""
                }
                
                isVerifying = false
            }
        }
    }
    
    private func errorSection() -> some View {
        if !errorMessage.isEmpty {
            return AnyView(
                HStack {
                    Image("Error on light")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width*0.053)
                        .foregroundColor(Color("#a8000b"))
                    
                    Text(errorMessage)
                        .font(Font.custom("SFProText-Regular", size: FontSize.warning))

                    Spacer()
                }.accessibilityElement(children: .combine)
            )
        } else {
            return AnyView(EmptyView().accessibilityHidden(true))
        }
    }
    
    private func isReadyForCaptchaValidation(_ captcha: String) -> Bool {
        return captcha.count == desiredCaptchaLength
    }
    
    private func handleSendCaptcha() async {
        isSendingCaptcha = true
        await sendCaptcha()
        isSendingCaptcha = false
        resetCoolOffTime()
        isCoolingOff = true
        errorMessage = ""
    }
    
    private func getMessage() -> String {
        guard message.isEmpty else {
            return message
        }
        
        switch contactInfo.type {
        case .email:
            return "Please enter the code that we have emailed to"
        case .phoneNumber:
            return "Please enter the code that we have sent to"
        }
    }
    
    private func checkIfIsCoolingOff() -> Bool {
        switch contactInfo.type {
        case .phoneNumber:
            return otpManager.checkIfSMSIsCoolingOff()
        case .email:
            return otpManager.checkIfEmailIsCoolingOff()
        }
    }
    
    private func resetCoolOffTime() {
        switch contactInfo.type {
        case .phoneNumber:
            otpManager.resetSMSOTPCoolOffTime()
        case .email:
            otpManager.resetEmailOTPCoolOffTime()
        }
    }
    
    private func clearCoolOffTime() {
        switch contactInfo.type {
        case .phoneNumber:
            otpManager.clearSMSOTPCoolOffTime()
        case .email:
            otpManager.clearEmailOTPCoolOffTime()
        }
    }
    
    private func logOTPDismissDateTime() {
        switch contactInfo.type {
        case .phoneNumber:
            otpManager.logSMSOTPDismissDateTime()
        case .email:
            otpManager.logEmailOTPDismissDateTime()
        }
    }
    
    private func resetOTPDismissDateTime() {
        switch contactInfo.type {
        case .phoneNumber:
            otpManager.resetSMSOTPDismissDateTime()
        case .email:
            otpManager.resetEmailOTPDismissDateTime()
        }
    }
}

struct OTPVerification_Previews: PreviewProvider {
    static private let email = ContactInfo(value: Contact.email("test@OpenWallet.com"))
    static private let phoneNumber = ContactInfo(value: Contact.phoneNumber(PhoneNumber(areaCode: "86", number: "12345678987")))
    @State static private var verifyCaptchaErrorMessage: String = "Something is wrong, error code: 0X0000000X. "
    
    static func sendCode() async {

    }

    static var previews: some View {
        VStack(spacing: 20) {
            OTPVerification(contactInfo: email, email: "test@OpenWallet.com", sendCaptchaRightAway: false, sendCaptcha: sendCode, onCaptchaReady: { captcha in
                OHLogInfo(captcha)
                return true
            }, verifyCaptchaErrorMessage: $verifyCaptchaErrorMessage)
            .padding(.horizontal, 16)
            
            Divider()
            
            OTPVerification(contactInfo: phoneNumber, email: "test@OpenWallet.com", sendCaptchaRightAway: false, sendCaptcha: sendCode, onCaptchaReady: { captcha in
                OHLogInfo(captcha)
                return true
            })
            .padding(.horizontal, 16)
        }
    }
}
