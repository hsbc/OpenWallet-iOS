//
//  CaptchaSendResponse.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/21.
//

import Foundation

struct CaptchaSendResponse: Decodable {
    let token: String?
    let captcha: String?
}
