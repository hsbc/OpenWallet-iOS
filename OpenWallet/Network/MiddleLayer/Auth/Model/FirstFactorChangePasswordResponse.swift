//
//  FirstFactorChangePasswordResponse.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/29.
//

import Foundation
struct FirstFactorChangePasswordResponse: Decodable {
    let token: String
    var captcha: String?
}
