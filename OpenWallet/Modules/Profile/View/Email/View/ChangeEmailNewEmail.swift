//
//  ChangeEmailNewEmail.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/1/22.
//

import SwiftUI

struct ChangeEmailNewEmail: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: EmailViewModel
    
    var body: some View {
        VStack {
            TopBarView(title: viewModel.topBarTitle, backAction: {dismiss()})
            
            VStack {
                HStack {
                    Text("Step 2 of 3")
                        .font(Font.custom("SFProText-Medium", size: FontSize.callout))
                    Text("Verification")
                        .font(Font.custom("SFProText-Regular", size: FontSize.callout))
                    Spacer()
                }
                .padding([.top, .bottom], 12)
                
                ProgressView(value: 0.66)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color("#db0011")))
            }
            .padding(.bottom, 22)
            
            VStack(alignment: .leading) {
                Text("Please enter your new email address.")
                    .font(Font.custom("SFProText-Light", size: FontSize.callout))
                    .padding(.bottom, 8)
                
                Text("Enter new email")
                    .font(Font.custom("SFProText-Regular", size: FontSize.label))
                    .padding(.bottom, 4)
                InputTextField(inputText: $viewModel.newEmail, isErrorState: $viewModel.showNewEmailCheckError, onTextChange: { _ in
                    viewModel.clearNewEmailCheckError()
                })
            }
            
            if viewModel.showNewEmailCheckError {
                HStack {
                    Image("Error on light")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width*0.053)
                        .foregroundColor(Color("#a8000b"))
                    
                    Text(viewModel.newEmailCheckErrorMessage).font(Font.custom("SFProText-Regular", size: FontSize.warning))

                    Spacer()
                }
            }
            
            Spacer()
            
            NavigationLink(
                destination: ChangeEmailNewEmailVerification(viewModel: viewModel).modifier(HideNavigationBar()),
                isActive: $viewModel.showNewEmailVerificationStep
            ) {
                EmptyView()
            }
            
            ActionButton(text: "Next") {
                viewModel.checkEmail(viewModel.newEmail)
            }
            .padding(.bottom, 16)
        }
        .padding([.leading, .trailing], 16)
    }
}

struct ChangeEmailNewEmail_Previews: PreviewProvider {
    @State static var viewModel: EmailViewModel = EmailViewModel()
    
    static var previews: some View {
        ChangeEmailNewEmail(viewModel: viewModel)
    }
}
