//
//  ChangeEmailEmailVerification.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/1/22.
//

import SwiftUI

struct ChangeEmailEmailVerification: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: EmailViewModel
    
    var body: some View {
        VStack {
            TopBarView(title: viewModel.topBarTitle, backAction: {dismiss()})
            
            VStack {
                HStack {
                    Text("Step 1 of 3")
                        .font(Font.custom("SFProText-Medium", size: FontSize.callout))
                    Text("Verify identity")
                        .font(Font.custom("SFProText-Regular", size: FontSize.callout))
                    Spacer()
                }
                .padding([.top, .bottom], 12)
                
                ProgressView(value: 0.33)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color("#db0011")))
            }
            .padding(.bottom, 22)
            
            EmailVerificationView(
                email: viewModel.email,
                isEmailVerified: $viewModel.isEmailVerified,
                captcha: $viewModel.captcha,
                sendCaptcha: viewModel.authService.trySendingEmailCaptcha,
                verifyCaptcha: viewModel.authService.isEmailCaptchaAvailable
            )

            NavigationLink(
                destination: ChangeEmailNewEmail(viewModel: viewModel).modifier(HideNavigationBar()),
                isActive: $viewModel.isEmailVerified
            ) {
                EmptyView()
            }
            
            Spacer()
        }
        .padding([.leading, .trailing], 16)
    }
}

struct ChangeEmailEmailVerification_Previews: PreviewProvider {
    @State static var viewModel: EmailViewModel = EmailViewModel()
    
    static var previews: some View {
        ChangeEmailEmailVerification(viewModel: viewModel)
    }
}
