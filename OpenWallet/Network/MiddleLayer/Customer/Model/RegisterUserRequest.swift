//
//  RegisterUserRequest.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/29.
//

import Foundation
struct RegisterUserRequest: Encodable {
    let username: String
    let token: String
}
