//
//  ClosableView.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/2/22.
//

import SwiftUI

struct ClosableView<Content: View>: View {
    @Environment(\.dismiss) private var dismiss

    @ViewBuilder var content: Content
    
    var onCloseClick: (() -> Void)?
    
    var body: some View {
        GeometryReader { _ in
            content
                .overlay(alignment: .topLeading) {
                    Button {
                        if onCloseClick != nil {
                            onCloseClick!()
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image("Close")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 19.8, height: 19.8)
                    }
                    .offset(x: 18.1, y: 18.1)
                    .accessibilityHint("Click to close screen.")
                }
        }
    }
}

struct ClosableView_Previews: PreviewProvider {
    static var previews: some View {
        ClosableView {
            VStack {
                Image("Splash Screen_First Launch")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 339, height: 260, alignment: .center)
                    .padding(.top, 112)
                    .padding(.bottom, 30)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Did you know")
                            .font(Font.custom("SFProText-Light", size: FontSize.headline))
                        Spacer()
                    }
                    Text("OpenWallet is launching")
                        .font(Font.custom("SFProText-Light", size: FontSize.headline))
                    Text("its very first NFT?")
                        .font(Font.custom("SFProText-Light", size: FontSize.headline))
                }
                .padding(.bottom, 16)
                .accessibilityElement(children: .combine)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Learn more about blockchain")
                            .font(Font.custom("SFProText-Light", size: FontSize.title3))
                        Spacer()
                    }
                    Text("and win your unique NFT.")
                        .font(Font.custom("SFProText-Light", size: FontSize.title3))
                }
                
                Spacer()
                
                ActionButton(text: "Find out more") {
                    // add action here
                }
                .padding(.bottom, 16)
            }
            .padding([.leading, .trailing], 18)
        }
    }
}
