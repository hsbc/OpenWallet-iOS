//
//  RegisterResponseModels.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/26.
//

import Foundation
struct RegisterUsernameResponse: Decodable, Encodable {
    let token: String
    let captcha: String?
}
