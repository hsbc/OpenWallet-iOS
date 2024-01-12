//
//  FindUsernameSMSVerifyResponse.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/23.
//

import Foundation
// in the find my username flow, username will in this response
struct FindUsernameSMSVerifyResponse: Decodable {
    let username: String
}
