//
//  VerificationView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/13.
//

import SwiftUI

struct VerificationView<Content: View>: View {
    @ObservedObject var otpManager = OTPManager.shared
    var contactInfo: ContactInfo
    var sendCaptcha: (_ sendAddress: String) async throws -> Bool
    var verifyCaptcha: ((_ sendAddress: String, _ captcha: String) async throws -> Bool)?
    
    @State var resendCaptchaCoolOffTime: Double = 300
    
    @State private var _captcha: String = ""
    @State private var isCaptchaSent: Bool = false
    @State private var hasTriedSendingCaptcha: Bool = false
    @Binding var apiErrorMessage: String
    @Binding var showApiErrorMessage: Bool
    
    @State private var isVerificationFailed: Bool = false
    
    @State private var navigate: Bool = false
    @State private var inputPin: String = ""
    @ViewBuilder var destination: Content
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: destination, isActive: $navigate) {
                EmptyView()
            }
            
            VStack(alignment: .leading, spacing: UIScreen.screenHeight * 0.01) {
                Text(getTipsText())
                    .font(Font.custom("SFProDisplay-Regular", size: FontSize.body))
                
                Text(contactInfo.getMaskedValue())
                    .font(Font.custom("SFProDisplay-Regular", size: FontSize.title4))
                    .padding(.bottom, UIScreen.screenHeight*0.02)
            }
            
            VStack(spacing: 4) {
                HStack {
                    
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
                                .foregroundColor(contactInfo.stringifiedValue.isEmpty ? .gray : Color("#14a5ab"))
                        }
                        .disabled(contactInfo.stringifiedValue.isEmpty)
                    }
                }
                
                PasscodeField(pin: $inputPin, disableInput: contactInfo.type == .phoneNumber ? $otpManager.smsVerifyLimit : $otpManager.emailVerifyLimit, onFinishInput: { pinCode in
                    OHLogInfo("pincode is \(pinCode)")
                    Task {
                        await verifyCaptcha(pinCode: pinCode)
                    }
                    
                })
                if showApiErrorMessage {
                    HStack {
                        Image("Error on light")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width*0.053)
                            .foregroundColor(Color("#a8000b"))
                        
                        Text(apiErrorMessage).font(Font.custom("SFProText-Regular", size: FontSize.warning))
                        
                        Spacer()
                    }
                    .padding(.top, 12)
                }
            }
        }
        .task {
            guard !hasTriedSendingCaptcha else { return }
            await sendCaptcha()
        }
    }
}

extension VerificationView {
    private func getTipsText() -> String {
        switch contactInfo.type {
        case .email:
            return "Please enter the code that we have emailed to"
        case .phoneNumber:
            return "Please enter the code that we have sent to"
        }
    }

    private func sendCaptcha() async {
        do {
            OHLogInfo("EmailVerificationView - send captcha")
            hasTriedSendingCaptcha = true
            isCaptchaSent = try await sendCaptcha(contactInfo.stringifiedValue)
            //            errorMessage = ""
        } catch {
            isCaptchaSent = false
            //            errorMessage = "Failed to send verification code."
        }
    }
    
    private func verifyCaptcha(pinCode: String) async {
        do {
            if let verifyCaptcha = verifyCaptcha {
                navigate =  try await verifyCaptcha(contactInfo.stringifiedValue, pinCode)
            }
        } catch {
            isVerificationFailed = true
            //            errorMessage = "Failed to validate email and captcha."
            inputPin = ""
            
        }    }
    
}

struct VerificationView_Previews: PreviewProvider {
    static private let email = "Test@OpenWallet.com"
    
    static func sendCode(_ email: String) async -> Bool {
        return true
    }
    
    static func verifyCode(_ email: String, _ captcha: String) async -> Bool {
        return true
    }
    
    @State static var isCaptchaReady: Bool = false
//   @ObservedObject var viewModel = RegisterViewModel()
    @ObservedObject var viewModel: RegisterViewModel

    static var previews: some View {
        ClosableView {
                    EmptyView()
            }
            .padding(.top, UIScreen.screenHeight*0.084)
            .padding([.leading, .trailing], 16)
        }
}
