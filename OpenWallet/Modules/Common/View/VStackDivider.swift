//
//  Dividers.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 5/26/22.
//

import SwiftUI

/**
 A Divider can be used to seperate elements in VStack. Support customized color and width
 */
struct VStackDivider: View {
    var color: Color = Color.gray.opacity(0.2)
    var width: CGFloat = 15
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
    }
}
