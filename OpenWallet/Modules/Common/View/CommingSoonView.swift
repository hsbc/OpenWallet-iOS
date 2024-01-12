//
//  CommingSoonView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/7.
//

import SwiftUI

struct CommingSoonView: View {
    var body: some View {
        ZStack {
            Color(.white).ignoresSafeArea()
            VStack(spacing: 0) {
                Group {
                    Image(systemName: "exclamationmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width*0.128)
                        .foregroundColor(Color("#305a85"))
                        .accessibilityHidden(true)
                    
                    Text("Coming soon!")
                        .font(Font.custom("SFProDisplay-Regular", size: FontSize.title1))
                        .padding(.top, 16)
                    
                }
                .accessibilityElement(children: .combine)
            }
        }
    }
}

struct CommingSoonView_Previews: PreviewProvider {
    static var previews: some View {
        CommingSoonView()
    }
}
