//
//  TopBarView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/5/25.
//

import SwiftUI

struct TopBarView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var title: String = ""
    @State var hideBackButton: Bool = false

    var backAction: (() -> Void)?
    
    var body: some View {
        ZStack(alignment: .center) {
            if !hideBackButton {
                HStack {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            guard backAction != nil else { return }
                            backAction!()
                        }
                    
                    Spacer()
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Back to the previous page")

            }
            Text(title)
                .font(Font.custom("SFProText-Medium", size: FontSize.body))
                .frame(height: 24)
        }
        .padding(.vertical, 10)
    }
}

struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TopBarView(title: "Put Bar Header Here")
            Spacer()
        }
        .padding([.leading, .trailing], 11)

    }
}
