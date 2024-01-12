//
//  ChangeEmailNewEmailVerification.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/1/22.
//

import SwiftUI

struct ChangeEmailNewEmailVerification: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: EmailViewModel

    var body: some View {
        VStack {
            TopBarView(title: viewModel.topBarTitle, backAction: {dismiss()})
            
            VStack {
                HStack {
                    Text("Step 3 of 3")
                        .font(Font.custom("SFProText-Medium", size: FontSize.callout))
                    Text("Verify identity")
                        .font(Font.custom("SFProText-Regular", size: FontSize.callout))
                    Spacer()
                }
                .padding([.top, .bottom], 12)
                
                ProgressView(value: 1)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color("#db0011")))
            }
            .padding(.bottom, 22)
            
            EmailVerificationView(
                email: viewModel.newEmail,
                isEmailVerified: $viewModel.isNewEmailVerified,
                captcha: $viewModel.newEmailCaptcha,
                sendCaptcha: viewModel.authService.trySendingEmailCaptcha,
                verifyCaptcha: viewModel.authService.isEmailCaptchaAvailable,
                onCaptchaVerified: onNewEmailCaptchaVerified
            )
            
            Group {
                NavigationLink(
                    destination: SuccessView(
                        detailInfo: viewModel.updateEmailSuccessfullyMessage,
                        buttonText: "Back to my Profile",
                        destination: {
                            MainView().modifier(HideNavigationBar())
                        }
                    ).modifier(HideNavigationBar()),
                    isActive: $viewModel.updateEmailSuccessfully
                ) {
                    EmptyView()
                }
                
                NavigationLink(
                    destination: FailureView(
                        destination: {
                            MainView().modifier(HideNavigationBar())
                        }
                    ).modifier(HideNavigationBar()),
                    isActive: $viewModel.failedToUpdateEmail
                ) {
                    EmptyView()
                }
            }
            
            Spacer()
        }
        .padding([.leading, .trailing], 16)
    }
}

extension ChangeEmailNewEmailVerification {
    func onNewEmailCaptchaVerified(_ isNewEmailAddressVerified: Bool) {
        guard isNewEmailAddressVerified else { return }
        viewModel.updateEmailAddress()
    }
}

struct ChangeEmailNewEmailVerification_Previews: PreviewProvider {
    @State static var viewModel: EmailViewModel = EmailViewModel()
    
    static var previews: some View {
        ChangeEmailNewEmailVerification(viewModel: viewModel)
    }
}
