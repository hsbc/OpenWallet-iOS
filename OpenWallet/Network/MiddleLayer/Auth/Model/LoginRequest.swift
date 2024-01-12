//
//  loginRequest.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/19.
//

import Foundation

struct LoginRequest: Encodable {
    let username: String
    let password: String
}
