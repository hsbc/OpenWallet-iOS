//
//  ErrorView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/12.
//

import SwiftUI

struct ErrorView<Content: View>: View {
    @State var errorMessage: String = "Sorry, something went wrong."
    
    @ViewBuilder var buttons: Content
    
    @State private var navigateToWelcome: Bool = false
    @State private var navigateToHome: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Image("error")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.screenWidth)
                .padding(.top, UIScreen.screenHeight * 0.039)
                .padding(.bottom, UIScreen.screenHeight * 0.049)
            
            VStack(alignment: .leading) {
                Text("Error")
                    .font(Font.custom("SFProDisplay-Regular", size: FontSize.largeHeadline))
                Text(errorMessage)
                    .font(Font.custom("SFProText-Light", size: FontSize.button))
                    .foregroundColor(Color("#333333"))
                
                Spacer()
                
                buttons
                    .padding(.bottom, 16)
            }
            .padding(.horizontal, 16)
        }
    }
    
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView {
            NavigationLink(
                destination: WelcomeView().modifier(HideNavigationBar())
            ) {
                ActionButton(text: "Go back")
                    .disabled(true) // Disable the ActionButton so that click action could propogate to the NavigationLink. [weihao.zhang]
            }
        }

        ErrorView(errorMessage: "One or more of the details you entered does not match the information on our records.") {
            VStack(spacing: 7) {
                ActionButton(text: "Try again") {}
                ActionButton(text: "Go back to home", isPrimaryButton: false) {}
            }
        }
    }
}
