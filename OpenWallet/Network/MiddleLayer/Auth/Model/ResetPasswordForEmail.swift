//
//  ResetForEmail.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/6/30.
//

import Foundation

struct ResetPasswordForEmail: Encodable {
    let email: String
    let newPassword: String
    var token: String?
    
}
