//
//  RegisterRequestModels.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/26.
//

import Foundation
struct RegisterCaptchaSendEmailRequest: Encodable {
    let username: String
    let token: String
    let emailAddress: String
    let captchaScenarioEnum: String
    let captchaTypeEnum: String
}

struct RegisterCaptchaSendSMSRequest: Encodable {
    let username: String
    let token: String
    let phoneCountryCode: String
    let phoneNumber: String
    let captchaScenarioEnum: String
    let captchaTypeEnum: String
}

struct RegisterCaptchaValidateRequest: Encodable {
    let username: String
    let captcha: String
    let token: String
    let captchaScenarioEnum: String
    let captchaTypeEnum: String
}
