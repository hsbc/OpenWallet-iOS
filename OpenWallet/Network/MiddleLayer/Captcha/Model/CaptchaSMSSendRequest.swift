//
//  CaptchaSMSSendRequest.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/23.
//

import Foundation
struct CaptchaSMSSendRequest: Encodable {
    let phoneCountryCode: String
    let phoneNumber: String
    let token: String
    let captchaScenarioEnum: String
    let captchaTypeEnum: String
}
