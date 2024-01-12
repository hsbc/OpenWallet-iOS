//
//  OnBoarding.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/12.
//

import SwiftUI

struct OnBoarding: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var navigationState: NavigationStateForRegister = NavigationStateForRegister.shared

    @State var isActive: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationLink(
                destination: RegisterUsername().modifier(HideNavigationBar()),
                isActive: $navigationState.registerToRoot
            ) {
                EmptyView()
            }.isDetailLink(false)

            TopBarView(
                backAction: { dismiss() }
            )
            .padding(.top, UIScreen.screenHeight*0.0136)
            .padding(.horizontal, PaddingConstant.widthPadding16)
            
            Image("register-people")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: UIScreen.screenWidth)
            
            Text("Register")
                .font(Font.custom("SFProDisplay-Regular", size: FontSize.largeHeadline))
                .padding(.top, UIScreen.screenHeight*0.02)
                .padding(.leading, UIScreen.screenWidth*0.064)
            Text("Creating your account will take less than 5 minutes!")
                .font(Font.custom("SFProText-Light", size: FontSize.title4))
                .padding(.top, UIScreen.screenHeight*0.01)
                .padding(.bottom, UIScreen.screenHeight*0.03)
                .padding(.leading, UIScreen.screenWidth*0.064)
                .padding(.trailing, UIScreen.screenWidth*0.094)

            VStack(spacing: 0) {
                processRow(step: "1", labelText: "Set up username", isLastItem: false)
                processRow(step: "2", labelText: "Set up password", isLastItem: false)
                processRow(step: "3", labelText: "Register with your email address", isLastItem: false)
                processRow(step: "4", labelText: "Register with your mobile phone number", isLastItem: true)
            }
            .padding(.leading, UIScreen.screenWidth*0.064)
            Spacer()
            ActionButton(text: "Next", isPrimaryButton: false) {
                navigationState.registerToRoot = true
            }
            .viewAppearLogger(self)
            .padding(.bottom, PaddingConstant.heightPadding16)
            .padding(.horizontal, PaddingConstant.widthPadding16)
        }
    }
}

extension OnBoarding {
    func processRow(step: String, labelText: String, isLastItem: Bool) -> some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .center, spacing: 0) {
                Image("step indeicator\(step)")
                if !isLastItem {
                Text("")
                    .frame(width: 1)
                    .background(Color("#797979"))
                }
            }
            .padding(.trailing, UIScreen.screenWidth*0.035)
            Text(labelText)
                .font(Font.custom("SFProText-Light", size: FontSize.body))
                .padding(.top, 3)
            Spacer()
        }
    }
}

struct OnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding()
    }
}
