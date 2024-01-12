//
//  UserProfile.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/7/22.
//

import Foundation

struct UserProfile: Decodable {
    let token: String
    let refreshToken: String
    let type: String
    let accountId: String
    let username: String
    let email: String
    let roles: [String]
}
