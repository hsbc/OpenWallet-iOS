//
//  Data.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/21.
//

import Foundation
/// Convert Data to String
extension Data {
    func toString() -> String {
        return String(decoding: self, as: UTF8.self)
    }
}
