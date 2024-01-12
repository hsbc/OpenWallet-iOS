//
//  SendVerificationView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/6/30.
//

import SwiftUI

struct SendVerificationView: View {
    @State var isVerificationCodeResent: Bool = false
    @Binding var isVerificationEmailSent: Bool 
    @State var resendVerificationCoolOffTime: Double = 60
    var callback: (() -> Void)?
    
    var body: some View {
        HStack {
            Text("Verification code")

            Spacer()
            
            if self.isVerificationCodeResent {
                CountdownTimer(
                    timeRemaining: $resendVerificationCoolOffTime,
                    timeIsUp: self.resetResendCode
                )
                .foregroundColor(Color("#14a5ab"))
            } else {
                
                Button(action: sendCodeAction,
                       label: {
                    Text(self.isVerificationEmailSent ? "Resend code" : "Send code")
                        .fontWeight(.semibold)
                        .foregroundColor(Color("#14a5ab"))
                })
                
            }
        }
        .padding(.top)
        .onAppear {
            // send email automatically when appearing this page
            sendCodeAction()
        }
    }
}

extension SendVerificationView {
    func sendCodeAction() {
        self.isVerificationCodeResent = true
        guard callback != nil else { return }
        callback!()
    }
    
    func resetResendCode() {
        self.isVerificationCodeResent = false
    }
}

struct SendVerificationView_Previews: PreviewProvider {
    @State static var isVerificationEmailSent: Bool=false
    static var previews: some View {
        SendVerificationView(isVerificationEmailSent: $isVerificationEmailSent)
    }
}
