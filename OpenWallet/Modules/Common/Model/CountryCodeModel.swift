//
//  CountryCodeModel.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/8/31.
//

import Foundation

struct CountryCodeModel: Decodable, Hashable {
    var code: Int
    var country: String
}
