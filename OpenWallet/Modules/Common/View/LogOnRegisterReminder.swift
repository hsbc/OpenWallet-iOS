//
//  LogOnRegisterReminder.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/27/22.
//

import SwiftUI

struct LogOnRegisterReminder: View {
    var body: some View {
        HStack {
            Image("Warning on light")
                .background(Color.black)
                .clipShape(Circle())
                .padding(.leading, 16)
            Text("Please Log on / Register")
            Spacer()
        }
        .frame(minWidth: 100, idealWidth: 359, maxWidth: .infinity, minHeight: 44, idealHeight: 44, maxHeight: 44)
        .background(Color("#fff8ea"))
        .border(Color("#ffbb33").opacity(0.7), width: 1)
    }
}

struct LogOnRegisterReminder_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LogOnRegisterReminder()
                .padding([.leading, .trailing])
        }
    }
}
