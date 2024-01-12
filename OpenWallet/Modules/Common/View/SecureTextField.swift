//
//  SecureTextField.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/4/22.
//

import SwiftUI

struct SecureTextField: View {
    @State var label: String = ""
    @Binding var inputText: String
    @Binding var isTextVisable: Bool

    var isErrorState: Binding<Bool>?

    @State var hideVisibleToggler: Bool = false
    @State var height: CGFloat = 48
    @State var iconWidth: CGFloat = 20
    
    @FocusState var isFocused: Bool

    @State private var borderColor: Color = Color("#000000")
    @State private var borderColorOnError: Color = Color("#a8000b")
    
    @State private var backgroundColor: Color = Color("#FFFFFF")
    @State private var backgroundColorOnError: Color = Color("#f9f2f3")

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !label.isEmpty {
                Text(label)
                    .font(Font.custom("SFProText-Regular", size: FontSize.label))
            }

            HStack {
                if isTextVisable {
                    TextField("", text: $inputText)
                } else {
                    SecureField("", text: $inputText)
                }
                Rectangle()
                    .fill(.clear)
                    .frame(width: 20)
            }
            .padding()
            .autocapitalization(.none)
            .frame(height: height)
            .border(isOnErrorState ? borderColorOnError : borderColor, width: 1)
            .background(isOnErrorState ? backgroundColorOnError : backgroundColor)
            .font(Font.custom("SFProText-Light", size: FontSize.body))
            .focused($isFocused)
            .overlay(alignment: .trailing) {
                if !hideVisibleToggler {
                    VStack {
                        Image(isTextVisable ? "Eye full" : "Eye")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                    }
                    .frame(width: 50, height: 50, alignment: .center)  // Create a large tappable area. [weihao.zhang]
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isTextVisable.toggle()
                    }
                }
            }
            .overlay(alignment: .bottom) {
                if isFocused && !isOnErrorState {
                    Rectangle()
                        .fill(Color("#000000"))
                        .frame(height: 3)
                }
            }
            .onDisappear {
                isTextVisable = false
            }
        }
    }
}

extension SecureTextField {
    var isOnErrorState: Bool {
        return isErrorState != nil && isErrorState!.wrappedValue
    }
}

struct SecureTextField_Previews: PreviewProvider {
    @State static var input: String = "test test test"
    @State static var isVisable: Bool = false
    
    static var previews: some View {
        VStack {
            SecureTextField(label: "Secure input box label", inputText: $input, isTextVisable: $isVisable, isErrorState: .constant(false))
            SecureTextField(label: "Secure input box label", inputText: $input, isTextVisable: $isVisable, isErrorState: .constant(true))
        }
        .padding()
    }
}
