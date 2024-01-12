//
//  CaptchaSendRequest.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/21.
//

import Foundation

struct CaptchaSendRequest: Encodable {
    let username: String
    let token: String
    let captchaScenarioEnum: CaptchaScenarioEnum
    let captchaTypeEnum: CaptchaTypeEnum
}
