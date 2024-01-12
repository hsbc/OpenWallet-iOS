//
//  RequestRedemptionResponse.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/29/22.
//

import Foundation

struct RequestRedemptionResponse: Decodable {
    let id: Int
    let receiverName: String?
    let phoneCountryCode: String?
    let phoneNumber: String?
    let postCode: String?
    let address1: String?
    let address2: String?
    let address3: String?
    let updateTime: String?
    let createTime: String?
}
