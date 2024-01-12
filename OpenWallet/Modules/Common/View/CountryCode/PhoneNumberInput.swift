//
//  PhoneNumberInput.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/1/22.
//

import SwiftUI

struct PhoneNumberInput: View {
    
    @Binding var countryCode: String
    @Binding var phoneNumber: String
    
    @State private var showSheet = false
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Area code")
                    .font(Font.custom("SFProText-Regular", size: FontSize.label))
                    .foregroundColor(Color("#333333"))
                
                Text(countryCode.isEmpty ? "" : "+\(countryCode)")
                    .padding()
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .frame(width: 100, height: 48, alignment: .leading)
                    .border(Color("#000000"), width: 1)
                    .foregroundColor(Color("#333333"))
                    .font(Font.custom("SFProText-Medium", size: FontSize.body))
                    .overlay(alignment: .trailing) {
                        Image("Chevron Down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 13)
                            .padding()
                    }
            }
            .onTapGesture {
                showSheet = true
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Click here to choose area code")

            Spacer()
            VStack {
                InputTextField(label: "Mobile phone number", inputText: $phoneNumber, acceptNumericValueOnly: true)
            }
        }
        .sheet(isPresented: $showSheet, content: {
            CountryCodes(countryCode: $countryCode, isShow: $showSheet)
        })
    }
}

struct PhoneNumberInput_Previews: PreviewProvider {
    @State static var countryCode: String = "86"
    
    @State static var phoneNumber: String = ""
    
    static var previews: some View {
        PhoneNumberInput(countryCode: $countryCode, phoneNumber: $phoneNumber)
            .padding(.horizontal)
    }
}
