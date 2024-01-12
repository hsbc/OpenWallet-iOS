//
//  PopUpView.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/21/22.
//

import SwiftUI

struct PopUpSettings {
    var title: String
    var messages: [String]
    var buttonText: String
}

struct PopUpView: View {
    var settings: PopUpSettings

    @Binding var show: Bool
    
    var dismissAction: (() -> Void)?

    var body: some View {
        ZStack {
            if show {
                // PopUp background color
                Color("#000000").opacity(show ? 0.2 : 0).edgesIgnoringSafeArea(.all)

                // PopUp Window
                VStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(settings.title)
                            .frame(height: 30, alignment: .center)
                            .font(Font.custom("SFProDisplay-Regular", size: FontSize.title2))

                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(settings.messages, id: \.self) { message in
                                Text(message)
                                    .font(Font.custom("SFProText-Regular", size: FontSize.info))
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        
                        Spacer()

                        Button(action: {
                            show = false
                            dismissAction?()
                        }, label: {
                            Text(settings.buttonText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48, alignment: .center)
                                .background(Color("#db0011"))
                                .foregroundColor(.white)
                                .font(Font.custom("SFProText-Medium", size: FontSize.button))
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }
                .background(.white)
                .shadow(color: .black.opacity(0.10), radius: 8, x: 0, y: 4)
                .frame(width: UIScreen.main.bounds.width - 32,
                       height: UIScreen.main.bounds.height * 0.239)
                .padding(.bottom, UIScreen.main.bounds.height * 0.134)
            }
        }
    }
}

struct PopUpView_Previews: PreviewProvider {
    @State static var showPopup: Bool = true

    static var popupSettings = PopUpSettings(
        title: "Timeout notification",
        messages: ["Your session has expired due to timed out."],
        buttonText: "Got it"
    )
    
    static var previews: some View {
        PopUpView(settings: popupSettings, show: $showPopup)
    }
}
