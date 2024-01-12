//
//  CaptchaSMSVerifyResetPasswordRequest.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/27.
//

import Foundation
struct CaptchaSMSVerifyResetPasswordRequest: Encodable {
    let emailAddress: String
    let captcha: String
    let token: String
    let captchaScenarioEnum: String
    let captchaTypeEnum: String
}
