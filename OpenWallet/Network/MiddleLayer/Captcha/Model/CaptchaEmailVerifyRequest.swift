//
//  CaptchaEmailVerifyRequest.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/23.
//

import Foundation
struct CaptchaEmailVerifyRequest: Encodable {
    let emailAddress: String
    let token: String
    let captcha: String
    let captchaScenarioEnum: String
    let captchaTypeEnum: String
}
