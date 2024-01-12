//
//  CustomerProfile.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/19/22.
//

import Foundation

struct CustomerProfile: Decodable {
    let username: String
    let emailAddress: String
    let phoneCountryCode: String
    let phoneNumber: String
    let avatar: String
    let marketingEnabled: Bool
    let roles: [String]
}
