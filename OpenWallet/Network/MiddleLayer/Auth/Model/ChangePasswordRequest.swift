//
//  changePasswordRequest.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/28.
//

import Foundation
struct ChangePasswordRequest: Encodable {
    let password: String
    var token: String
}
