//
//  EmptyButtonStyle.swift
//  OpenWallet
//
//  Created by Jianrong Fan on 2022/10/18.
//

import SwiftUI

struct EmptyButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}
