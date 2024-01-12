//
//  ProgressBar.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/9.
//

import SwiftUI

struct ProgressBar: View {
    var step: Int = 1
    var processBarText: String {
        switch step {
        case 1:
            return "Set up username"
        case 2:
            return "Set up password"
        case 3:
            return "Verify email address"
        case 4:
            return "Verify mobile phone number"
        default:
            return ""
        }
    }
    var body: some View {
        VStack {
            HStack {
                Text("Step \(step) of 4")
                    .font(Font.custom("SFProText-Medium", size: FontSize.label))
                Text(processBarText)
                    .font(Font.custom("SFProText-Regular", size: FontSize.label))
                Spacer()
            }

            ProgressView(value: Float16(CGFloat(step)/4))
                .progressViewStyle(LinearProgressViewStyle(tint: Color("#db0011")))
        }
        .padding(.top, UIScreen.screenWidth*0.0299)
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(step: 2)
    }
}
