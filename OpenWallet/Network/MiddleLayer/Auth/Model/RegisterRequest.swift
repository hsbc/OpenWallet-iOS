//
//  RegisterRequest.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/8/3.
//

import Foundation

struct RegisterRequest: Encodable {
    let emailAddress: String
    let password: String
    let phoneCountryCode: String?
    let phoneNumber: String?
    let referBy: String?
    let username: String
    let verificationCode: String
    
    init(emailAddress: String, password: String, username: String, verificationCode: String) {
        self.emailAddress = emailAddress
        self.password = password
        self.username = username
        self.verificationCode = verificationCode
        
        self.phoneCountryCode = nil
        self.phoneNumber = nil
        self.referBy = nil
    }

    init(
        emailAddress: String,
        password: String,
        phoneCountryCode: String,
        phoneNumber: String,
        referBy: String,
        username: String,
        verificationCode: String
    ) {
        self.emailAddress = emailAddress
        self.password = password
        self.phoneCountryCode = phoneCountryCode
        self.phoneNumber = phoneNumber
        self.referBy = referBy
        self.username = username
        self.verificationCode = verificationCode
    }
}
