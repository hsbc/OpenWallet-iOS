//
//  SignInRedirector.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/12/22.
//

import SwiftUI

struct SignInRedirector: View {
    
    @State var navigate: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                VStack(spacing: 16) {
                    HStack {
                        Image("Information on light")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.128)
                            .foregroundColor(Color("#305a85"))
                            .accessibilityHidden(true)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Please log on / register")
                            .font(Font.custom("SFProDisplay-Regular", size: FontSize.title1))
                        
                        Text("Please click the button to log on or register!")
                            .font(Font.custom("SFProText-Regular", size: FontSize.body))
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Information. Please log on / register first.")
                
                Spacer()
                
                VStack {
                    NavigationLink(
                        destination: WelcomeView().navigationBarHidden(true),
                        isActive: $navigate
                    ) {
                        EmptyView()
                    }
                    .accessibilityHidden(true)
                    
                    ActionButton(text: "Go", action: {
                        navigate.toggle()
                    })
                    .padding([.horizontal, .bottom], 16)
                    .accessibilityHint("Click to go to log on / register page.")
                }
            }
        }
    }
}

struct SignInRedirector_Previews: PreviewProvider {
    static var previews: some View {
        SignInRedirector()
    }
}
