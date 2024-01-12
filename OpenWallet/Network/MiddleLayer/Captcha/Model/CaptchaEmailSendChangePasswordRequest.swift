//
//  CaptchaEmailSendChangePasswordRequest.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/28.
//

import Foundation
struct CaptchaEmailSendChangePasswordRequest: Encodable {
    let emailAddress: String
    let token: String
    let captchaScenarioEnum: String
    let captchaTypeEnum: String

}
