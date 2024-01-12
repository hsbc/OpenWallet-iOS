//
//  ViewModifiers.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 5/26/22.
//

import SwiftUI

struct HideNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            // Need to set NavigationBarTitle to an empty string in order to make navigationBarHidden works. [weihao.zhang]
            .navigationTitle("")
            .navigationBarTitle("")
            .navigationBarHidden(true)
    }
}
