//
//  TextFieldLengthLimit.ViewModifiers.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/31/22.
//

import SwiftUI
import Combine

struct TextFieldLengthLimit: ViewModifier {
    @Binding var value: String
    var length: Int

    func body(content: Content) -> some View {
        if #available(iOS 14, *) {
            content
                .onChange(of: $value.wrappedValue) {
                    if $0.count > length {
                        value.removeLast()
                    }
                }
        } else {
            content
                .onReceive(Just(value)) {
                    if $0.count > length {
                        value.removeLast()
                    }
                }
        }
    }
}

extension View {
    func limitInputLength(value: Binding<String>, length: Int) -> some View {
        self.modifier(TextFieldLengthLimit(value: value, length: length))
    }
}
