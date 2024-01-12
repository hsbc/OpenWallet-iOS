//
//  FirstFactor.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/19.
//

import Foundation

struct FirstFactorResponseData: Decodable {
    let token: String
    let maskedEmail: String
    let maskedPhoneNumber: String
    let captcha: String?
}
