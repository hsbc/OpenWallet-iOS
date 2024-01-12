//
//  CustomerBankInfo.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/28/22.
//

import Foundation

struct CustomerBankInfo: Decodable {
    let legalName: String
    let phoneCountryCode: String
    let phoneNumber: String
}

extension CustomerBankInfo {
    var isEmptyBankInfo: Bool {
        return legalName.isEmpty || phoneCountryCode.isEmpty || phoneNumber.isEmpty
    }
}
