//
//  IpfsResult.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/21.
//

import Foundation

struct IpfsResult: Decodable {
    var name: String
    var description: String
    var image: IpfsImg
    var attributes: [IpfsAttribute]
}

struct IpfsImg: Decodable {
    var location: String
    var path: String
}

struct IpfsAttribute: Decodable {
    var trait_type: String
    var value: String
}
