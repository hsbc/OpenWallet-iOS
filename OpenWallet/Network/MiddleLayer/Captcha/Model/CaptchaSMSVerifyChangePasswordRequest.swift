//
//  CaptchaSMSVerifyChangePasswordRequest.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/28.
//

import Foundation
struct CaptchaSMSVerifyChangePasswordRequest: Encodable {
    let captcha: String
    let token: String
    let captchaScenarioEnum: String
    let captchaTypeEnum: String
}
