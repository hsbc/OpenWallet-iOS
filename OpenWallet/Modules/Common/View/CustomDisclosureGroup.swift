//
//  CustomDisclosureGroup.swift
//  OpenWallet
//
//  Created by Jianrong Fan on 2022/10/20.
//

import SwiftUI

struct CustomDisclosureGroup<Label: View, Content: View>: View {
    
    @State var isExpanded: Bool

    var actionOnClick: () -> Void
    var animation: Animation?
    
    let label: Label
    let content: Content
    
    init(animation: Animation? = .easeInOut(duration: 0.2), isExpanded: Bool = false, actionOnClick: @escaping () -> Void = {}, content: () -> Content, label: () -> Label) {
        self.actionOnClick = actionOnClick
        self._isExpanded = State(initialValue: isExpanded)
        self.animation = animation
        self.content = content()
        self.label = label()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                label
                Spacer()
                Image("Icon-right")
                    .rotationEffect(isExpanded ? Angle(degrees: 90) : .zero)
            }
            .padding(.leading, 16)
            .padding(.trailing, 11)
            .clipped()
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(animation) {
                    actionOnClick()
                    self.isExpanded.toggle()
                }
            }
            
            if isExpanded {
                content
            } else {
                Divider()
            }
        }
    }
}
