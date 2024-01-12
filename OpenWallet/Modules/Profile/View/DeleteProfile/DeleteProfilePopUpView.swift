//
//  DeleteProfilePopUpView.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/10/20.
//

import SwiftUI
struct DeleteProfilePopUpSettings {
    var title: String
    var messages: [String]
    var YesButtonText: String
    var NoButtonText: String?
    
}

struct DeleteProfilePopUpView: View {
    var settings: DeleteProfilePopUpSettings
    @Binding var show: Bool
    var yesButtonAction: (() -> Void)?
    var noButtonAction: (() -> Void)?
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
                        HStack {
                            if let noButtonTitle = settings.NoButtonText {
                                Button(action: {
                                    show = false
                                    noButtonAction?()
                                }, label: {
                                    Text(noButtonTitle)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 48, alignment: .center)
                                        .background(Color("#db0011"))
                                        .foregroundColor(.white)
                                        .font(Font.custom("SFProText-Medium", size: FontSize.button))
                                })
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            Button(action: {
                                show = false
                                yesButtonAction?()
                            }, label: {
                                Text(settings.YesButtonText)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48, alignment: .center)
                                    .foregroundColor(Color("#333333"))
                                    .background(.white)
                                    .font(Font.custom("SFProText-Medium", size: FontSize.button))
                                    .border(Color("#252525"), width: 1)
                            })
                            .buttonStyle(PlainButtonStyle())
                            
                        }
                    }
                    .padding(.horizontal, PaddingConstant.widthPadding16)
                    .padding(.vertical, PaddingConstant.heightPadding16)
                }
                .background(.white)
                .shadow(color: .black.opacity(0.10), radius: 8, x: 0, y: 4)
                .frame(width: UIScreen.main.bounds.width - PaddingConstant.widthPadding16 * 2,
                       height: UIScreen.main.bounds.height * 0.239)
                .padding(.bottom, UIScreen.main.bounds.height * 0.134)
            }
        }
    }
}

struct DeleteProfilePopUpView_Previews: PreviewProvider {
    @State static var showPopup: Bool = true
    static var popupSettings = DeleteProfilePopUpSettings(
        title: "Confirm deleting your profile?",
        messages: ["If so, you will no longer have access to this OpenWallet Open profile nor be allowed to register a new profile with your current registered profile information."],
        YesButtonText: "Yes",
        NoButtonText: "No"
    )
    static var previews: some View {
        DeleteProfilePopUpView(settings: popupSettings, show: $showPopup)
    }
}
