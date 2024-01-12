//
//  Image.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/2.
//

import SwiftUI

extension Image {
    @ViewBuilder
    func conditionalResizable(_ resizable: Bool) -> some View {
        if resizable {
            self.resizable()
        } else {
            self
        }
    }
}
