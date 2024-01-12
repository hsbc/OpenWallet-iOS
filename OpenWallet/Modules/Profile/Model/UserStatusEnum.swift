//
//  UserStatusEnum.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/10/19.
//

import Foundation
enum UserStatusEnum: String, Codable {
    case active = "ACTIVE"
    case closed = "CLOSED"
    case inactive = "INACTIVE"
    case closing = "CLOSING" // delete Profile using
}
