//
//  NFTTokenDetails.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/25/22.
//

import Foundation

class NFTTokenDetails: Decodable {
    let name: String
    let material: String
    let fineness: String
    let weight: String
    let goldItemInformation: String
    let imageList: [String]
    let ownedBy: String
    let status: NFTStatus
    let datetime: Int64
    let serialNumber: Int?
    
    init(
        name: String,
        material: String,
        fineness: String,
        weight: String,
        goldItemInformation: String,
        imageList: [String],
        ownedBy: String,
        status: NFTStatus,
        datetime: Int64,
        serialNumber: Int?
    ) {
        self.name = name
        self.material = material
        self.fineness = fineness
        self.weight = weight
        self.goldItemInformation = goldItemInformation
        self.imageList = imageList
        self.ownedBy = ownedBy
        self.status = status
        self.datetime = datetime
        self.serialNumber = serialNumber
    }
}
