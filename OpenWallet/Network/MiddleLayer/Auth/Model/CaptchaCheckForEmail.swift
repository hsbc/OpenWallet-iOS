//
//  CaptchaCheckForEmail.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 6/28/22.
//

import Foundation

struct CaptchaCheckForEmail: Encodable {
    let email: String
    let captcha: String?
}
