//
//  LogViewVisiable.swift
//  OpenWallet
//
//  Created by Jianrong Fan on 2022/10/31.
//

import SwiftUI

struct ViewAppearLogger: ViewModifier {
    let viewType: any View.Type
    let info: [String: Any]
    func body(content: Content) -> some View {
        content
            .onAppear {
                var logInfo = "\(viewType) appear"
                if info.keys.count > 0 {
                    logInfo += " info: \(info)"
                }
                OHLogInfo(logInfo)
            }
            .onDisappear {
                var logInfo = "\(viewType) disappear"
                if info.keys.count > 0 {
                    logInfo += " info: \(info)"
                }
                OHLogInfo(logInfo)
            }
    }
    
}

extension View {
    func viewAppearLogger(_ view: any View, info: [String: Any] = [:]) -> some View {
        modifier(ViewAppearLogger(viewType: type(of: view), info: info))
    }
    
}
