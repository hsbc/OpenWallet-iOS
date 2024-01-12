//
//  InputTextField.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/26/22.
//

import SwiftUI

struct InputTextField: View {
    @State var label: String = ""
    @Binding var inputText: String
    var isErrorState: Binding<Bool>?

    @State var acceptNumericValueOnly: Bool = false
    @State var textPlaceHolder: String = ""
    @State var height: CGFloat = 48
    @State var allowEdit: Bool = true
    
    @FocusState var isFocused: Bool
    
    @State private var borderColor: Color = Color("#000000")
    @State private var borderColorOnError: Color = Color("#a8000b")
    @State private var borderColorNotAllowEdit: Color = Color("#d7d8d6")
    
    @State private var backgroundColor: Color = Color("#FFFFFF")
    @State private var backgroundColorOnError: Color = Color("#f9f2f3")
    
    @State private var foregroundColor: Color = Color("#333333")
    @State private var foregroundColorNotAllowEdit: Color = Color("#d7d8d6")
    
    var onTextChange: ((_ newValue: String) -> Void)?
    var onFocusChange: ((_ isOnFocus: Bool) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !label.isEmpty {
                Text(label)
                    .font(Font.custom("SFProText-Regular", size: FontSize.label))
                    .foregroundColor(getForegroundColor())
            }
            
            TextField(textPlaceHolder, text: $inputText)
                .keyboardType(acceptNumericValueOnly ? .numberPad : .default)
                .padding()
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(height: height)
                .border(getBorderColor(), width: 1)
                .background(getBackgroundColor())
                .foregroundColor(getForegroundColor())
                .font(Font.custom("SFProText-Medium", size: FontSize.body))
                .disabled(!allowEdit)
                .focused($isFocused)
                .onChange(of: inputText) { (newValue: String) in
                    if acceptNumericValueOnly {
                        let filteredValue = newValue.filter { "0123456789".contains($0) }
                        
                        if filteredValue != newValue {
                            inputText = filteredValue
                        }
                    }

                    onTextChange?(inputText)
                }
                .onChange(of: isFocused) { (isOnFocus: Bool) in
                    guard onFocusChange != nil else { return }
                    onFocusChange!(isOnFocus)
                }
                .overlay(alignment: .bottom) {
                    if isFocused {
                        Rectangle()
                            .fill(getBorderColor())
                            .frame(height: 3)
                    }
                }
                .accessibilityHint("You can input \(label) here.")
        }
    }
}

extension InputTextField {
    var isOnErrorState: Bool {
        isErrorState?.wrappedValue ?? false
    }
    
    func getBackgroundColor() -> Color {
        if !allowEdit {
            return backgroundColor
        }
        
        if isOnErrorState {
            return backgroundColorOnError
        }
        
        return backgroundColor
    }
    
    func getBorderColor() -> Color {
        if !allowEdit {
            return borderColorNotAllowEdit
        }
        
        if isOnErrorState {
            return borderColorOnError
        }
        
        return borderColor
    }
    
    func getForegroundColor() -> Color {
        if !allowEdit {
            return foregroundColorNotAllowEdit
        }
        
        return foregroundColor
    }
}

struct InputTextField_Previews: PreviewProvider {
    @State static var email1: String = "Test@OpenWallet.com"
    @State static var numbers: String = "123456"
    @State static var isErrorState: Bool = false
    
    static var previews: some View {
        VStack {
            InputTextField(label: "Input box label", inputText: $email1)
            InputTextField(label: "Numeric input only", inputText: $numbers, acceptNumericValueOnly: true)
        }
        .padding()
    }
}
