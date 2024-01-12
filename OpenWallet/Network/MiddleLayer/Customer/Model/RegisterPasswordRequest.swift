//
//  RegisterPasswordRequest.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/26.
//

// All the models in register flow
import Foundation
struct RegisterPasswordRequest: Encodable {
    let username: String
    let password: String
    let token: String
}
