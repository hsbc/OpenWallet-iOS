//
//  ActionButton.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/26/22.
//

import SwiftUI

struct ActionButton: View {
    @State var text: String
    
    var isPrimaryButton: Bool = true
    
    var isLoading: Binding<Bool>?
    var isDisabled: Binding<Bool>?
    var action: (() -> Void)?
    
    var body: some View {
        Button {
            guard !isDisabledState && !isLoadingState else {
                return
            }
            action?()
        } label: {
            Text(isLoadingState ? "" : text)
                .font(Font.custom("SFProText-Medium", size: FontSize.body))
                .frame(minWidth: 100, maxWidth: .infinity, minHeight: 48, idealHeight: 48, maxHeight: 48)
                .foregroundColor(isPrimaryButton ? .white : .black)
                .background(isPrimaryButton ? isDisabledState ? Color("#d4d4d4") : Color("#db0011") : .white)
                .border(.black, width: isPrimaryButton ? 0 : 1)
                .overlay(alignment: .center) {
                    if isLoadingState {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                }
        }
        .disabled(isDisabledState || isLoadingState)
    }
}

extension ActionButton {
    var isDisabledState: Bool {
        return isDisabled != nil && isDisabled!.wrappedValue
    }
    
    var isLoadingState: Bool {
        return isLoading != nil && isLoading!.wrappedValue
    }
}

struct ActionButton_Previews: PreviewProvider {
    @State static var disabled: Bool = true
    
    static var previews: some View {
        VStack {
            ActionButton(text: "Next", isDisabled: $disabled) {
                OHLogInfo("Button is clicked.")
            }
        }
        .padding()
    }
}
