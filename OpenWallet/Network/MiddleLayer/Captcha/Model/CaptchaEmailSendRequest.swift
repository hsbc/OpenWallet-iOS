//
//  CaptchaSendFindUsernameEmailRequest.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/23.
//

import Foundation
struct CaptchaEmailSendRequest: Encodable {
    let emailAddress: String
    let captchaScenarioEnum: String
    let captchaTypeEnum: String

}
