//
//  FailureView.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/3/22.
//

import SwiftUI

struct FailureView<Content: View>: View {
    @State var detailInfo: String = "Something went wrong."
    @State var buttonText: String = "Back"
    
    @ViewBuilder var destination: Content
    
    @State private var navigate: Bool = false
    
    var body: some View {
        VStack {
            Image("Error on light")
                .resizable()
                .scaledToFit()
                .frame(width: 48)
                .foregroundColor(Color("#00847f"))
                .padding(.top, 211.42)
                .padding(.bottom, 18.67)

            Text("Error")
                .font(Font.custom("SFProDisplay-Regular", size: FontSize.title1))
                .padding(.bottom, 8)

            Text(detailInfo)
                .font(Font.custom("SFProText-Regular", size: FontSize.body))

            Spacer()

            NavigationLink(destination: destination, isActive: $navigate) {
                EmptyView()
            }

            ActionButton(text: buttonText, action: {
                navigate.toggle()
            })
            .padding([.leading, .trailing, .bottom], 16)
        }
    }
}

struct FailureView_Previews: PreviewProvider {
    static var previews: some View {
        FailureView {
            EmptyView()
        }
    }
}
