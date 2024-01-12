//
//  ChangeEmailView.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/1/22.
//

import SwiftUI

struct ChangeEmailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: EmailViewModel = EmailViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
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
            
            Text("Press \"Next\" to recieve the verification code. ")
                .font(Font.custom("SFProText-Light", size: FontSize.callout))
                .padding(.bottom, 8)
            
            InputTextField(label: "Email address", inputText: $viewModel.email, allowEdit: false)
            
            Spacer()
            
            NavigationLink(
                destination: ChangeEmailEmailVerification(viewModel: viewModel).modifier(HideNavigationBar()),
                isActive: $viewModel.showEmailVerificationStep
            ) {
                EmptyView()
            }
            
            ActionButton(text: "Next") {
                viewModel.showEmailVerificationStep.toggle()
            }
            .padding(.bottom, 16)
        }
        .viewAppearLogger(self)
        .padding([.leading, .trailing], 16)
    }
}

struct ChangeEmailView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeEmailView()
    }
}
