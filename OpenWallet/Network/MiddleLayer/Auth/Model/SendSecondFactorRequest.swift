//
//  SendSecondFactorRequest.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/20.
//

import Foundation

struct SendSecondFactorRequest: Encodable {
    let secondFactorMethodEnum: String
    let token: String
    let username: String
}
