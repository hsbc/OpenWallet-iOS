//
//  UserContractsModel.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/21.
//

import Foundation

struct UserContract: Decodable {
    var assetType: String
    var contractAddress: String
}
