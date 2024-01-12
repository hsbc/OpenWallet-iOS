//
//  SignEndView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/5/26.
//

import SwiftUI

struct SuccessView<Content: View>: View {
    @State var mainHeadText: String = "Congratulations!"
    @State var detailInfo: String = ""
    @State var buttonText: String = ""
    @State var imageName: String = "congratulations"
    @State var subTitleText: String = ""
    @State var subInfoText: String = ""
    
    var buttonActionAsync: (() async -> Void)?

    @ViewBuilder var destination: Content
    
    @State private var navigate: Bool = false
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: UIScreen.screenHeight*0.356)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: UIScreen.screenHeight * 0.01) {
                Text(mainHeadText)
                    .font(Font.custom("SFProDisplay-Regular", size: FontSize.largeHeadline))
                    .padding(.bottom, 8)

                Text(detailInfo)
                    .font(Font.custom("SFProText-Light", size: FontSize.body))
                    .padding(.bottom, 46)

                Text(subTitleText)
                    .font(Font.custom("SFProText-Light", size: FontSize.body))
                    .padding(.bottom, 8)
                
                Text(subInfoText)
                    .font(Font.custom("SFProDisplay-Regular", size: FontSize.title2))

                Spacer()
                
                NavigationLink(destination: destination, isActive: $navigate) {
                    EmptyView()
                }
                
                ActionButton(text: buttonText, action: {
                    Task {
                        await buttonActionAsync?()
                        navigate.toggle()
                    }
                })
                .padding(.bottom, UIScreen.screenHeight * 0.02)
            }
            .padding(.horizontal, UIScreen.screenWidth * 0.043)
        }
    }
}

struct SuccessView_Previews: PreviewProvider {
    @State static var detailInfo: String = "You have successfully registered."

    static var previews: some View {
        SuccessView(detailInfo: detailInfo, buttonText: "Log on") {
            EmptyView()
        }
    }
}
