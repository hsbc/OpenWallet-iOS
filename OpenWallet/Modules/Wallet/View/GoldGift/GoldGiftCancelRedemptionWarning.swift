//
//  GoldGiftCancelRedemptionWarning.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/7.
//

import SwiftUI

struct GoldGiftCancelRedemptionWarning: View {
    var clickYesFunction: (() -> Void)?
    var clickNoFunction: (() -> Void)?
    var body: some View {
        ZStack {
            Color("#000000").opacity(0.2).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text("Cancel Gold X NFT – Gold Gift Redemption?")
                    .font(Font.custom("SFProText-Regular", size: FontSize.title2))
                Text("You are in the midst of requesting delivery of the Gold Gift. If you cancel now, you will have to submit it again.")
                    .font(Font.custom("SFProText-Regular", size: FontSize.label))
                    .foregroundColor(Color("#333333"))
                    .padding(.top, UIScreen.screenHeight*0.015)
                Spacer()
                HStack {
                    ActionButton(text: "No") {
                        clickNoFunction?()
                    }
                    .border(Color("#252525"), width: 1)

                    ActionButton(text: "Yes", isPrimaryButton: false) {
                        clickYesFunction?()
                    }
                }
            }
            .viewAppearLogger(self)
            .padding(UIScreen.screenWidth * 0.043)
            .frame(width: UIScreen.main.bounds.width * 0.915, height: UIScreen.main.bounds.height * 0.288)
            .background(.white)
        }
    }
}

struct GoldGiftCancelRedemptionWarning_Previews: PreviewProvider {
    static var previews: some View {
        GoldGiftCancelRedemptionWarning()
    }
}
