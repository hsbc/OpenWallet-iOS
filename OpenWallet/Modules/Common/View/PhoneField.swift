//
//  PhoneField.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/8/29.
//

import SwiftUI

struct PhoneField: View {
    @State var areaCode: String = ""
    @State var phoneNum: String = ""
    
    @State var phoneNumber = ""
    @State var y: CGFloat = UIScreen.screenHeight
    @State var countryCode = ""
    @State var countryFlag = ""

    var body: some View {
        VStack {
            GeometryReader { metrics in
                HStack(spacing: 0) {
                    VStack {
                        InputTextField(label: "Area code", inputText: $areaCode)
                    }
                    .frame(width: metrics.size.width * 0.291)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            self.y = 0
                        }
                    }
                    Spacer()
                    
                    VStack {
                        InputTextField(label: "Phone number", inputText: $phoneNum)

                    }.frame(width: metrics.size.width * 0.661)
                }
            }
        }.frame(height: 70)
    }
}

struct PhoneField_Previews: PreviewProvider {
    static var previews: some View {
        PhoneField()
    }
}
