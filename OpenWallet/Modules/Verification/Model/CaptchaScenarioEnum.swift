//
//  CaptchaScenarioEnum.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/22.
//

import Foundation

enum CaptchaScenarioEnum: String, Codable {
    case signIn = "SIGN_IN"
    case changePassword = "CHANGE_PASSWORD"
    case forgetUsername = "FORGOT_USERNAME"
    case register = "REGISTER"
    case resetPassword = "RESET_PASSWORD"
}
