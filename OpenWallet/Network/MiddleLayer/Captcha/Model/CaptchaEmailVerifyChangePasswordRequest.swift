//
//  CaptchaEmailVerifyChangePasswordRequest.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/28.
//

import Foundation
struct CaptchaEmailVerifyChangePasswordRequest: Encodable {
    let captcha: String
    let token: String
    let captchaScenarioEnum: String
    let captchaTypeEnum: String
}
