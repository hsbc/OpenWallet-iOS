//
//  ChangePasswordEmailVerification.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/27/22.
//

import SwiftUI

struct ChangePasswordEmailVerification: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: PasswordViewModel
    @State var scenario: ChangePasswordScenario
    @State var captchaScenario: CaptchaScenarioEnum = .changePassword
    @Binding var showChangePasswordView: Bool

    var body: some View {
        VStack {
            TopBarView(title: viewModel.getBarTitle(scenario), backAction: {dismiss()})
            
            VStack {
                HStack {
                    Text("Step 1 of 2")
                        .font(Font.custom("SFProText-Medium", size: FontSize.callout))
                    Text("Verify identity")
                        .font(Font.custom("SFProText-Regular", size: FontSize.callout))
                    Spacer()
                }
                .padding([.top, .bottom], 12)
                
                ProgressView(value: 0.5)
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
            
            // navigation to the password entering page after the user specified a captcha, do not do email captcha verification here. [weihao.zhang]
            NavigationLink(
                destination: EnterNewPasswordView(viewModel: viewModel, scenario: scenario, navigateToWorkflowRoot: .constant(true), showChangePasswordView: $showChangePasswordView).modifier(HideNavigationBar()),
                isActive: $viewModel.isEmailVerified
            ) {
                EmptyView()
            }
            
            Spacer()
        }
        .padding([.leading, .trailing], 16)
    }
}

struct ChangePasswordEmailVerification_Previews: PreviewProvider {
    @State static var viewModel: PasswordViewModel = PasswordViewModel()
    
    static var previews: some View {
        ChangePasswordEmailVerification(viewModel: viewModel, scenario: ChangePasswordScenario.changePassword, showChangePasswordView: .constant(false))
    }
}
