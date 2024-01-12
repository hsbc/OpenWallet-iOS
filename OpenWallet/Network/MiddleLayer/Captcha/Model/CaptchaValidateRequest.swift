//
//  CaptchaValidateRequest.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/20.
//

import Foundation

struct CaptchaValidateRequest: Encodable {
    let username: String
    let captcha: String
    let token: String
    let captchaScenarioEnum: CaptchaScenarioEnum
    let captchaTypeEnum: CaptchaTypeEnum
}
