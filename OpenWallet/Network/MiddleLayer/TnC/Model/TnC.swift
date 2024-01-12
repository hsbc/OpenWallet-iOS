//
//  TnC.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 10/9/22.
//

import Foundation

struct TnC: Decodable {
    let id: Int
    let content: String
    let language: String
    let region: String
    let category: TnCCategory
    let filePath: String
    let fileName: String
    let createTime: String
    let updateTime: String
}
