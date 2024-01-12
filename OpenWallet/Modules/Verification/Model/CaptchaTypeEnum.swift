//
//  CaptchaTypeEnum.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/22.
//

import Foundation

enum CaptchaTypeEnum: String, Codable {
    case mailVerify = "MAIL_VERIFY"
    case resetPassword = "RESET_PASSWORD"
    case smsVeyrif = "SMS_VERIFY"
}
