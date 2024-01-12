//
//  PhoneValidationRequest.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/20/22.
//

import Foundation

struct PhoneValidationRequest: Encodable {
    let countryCode: String
    let phoneNumber: String
}
