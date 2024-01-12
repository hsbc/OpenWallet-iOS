//
//  NFTBasicInfo.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/25/22.
//

import Foundation
import SwiftUI

class NFTBasicInfo: Decodable {
    var imageURI: [String]
    var tokenURI: String
    var datetime: Int64
    var name: String
    var nftId: Int
    var edition: String?
    var ownedBy: String
    var status: NFTStatus
    
    init(
        imageURI: [String],
        tokenURI: String,
        datetime: Int64,
        name: String,
        nftId: Int,
        edition: String?,
        ownedBy: String,
        status: NFTStatus
    ) {
        self.imageURI = imageURI
        self.tokenURI = tokenURI
        self.datetime = datetime
        self.name = name
        self.nftId = nftId
        self.edition = edition
        self.ownedBy = ownedBy
        self.status = status
    }
    
    func singlePreviewImageUrl() -> String {
        let temp: [String] = imageURI.filter { url in
            if url.contains(".webp") || url.contains("placeholder") {
                return false
            }
            return true
        }
        
        if temp.count == 0 {
            return ""
        }
        
        return temp.first ?? ""
    }
}

extension NFTBasicInfo {
    var isValidAsset: Bool {
        return nftId >= 0 // For now we assume an asset with nagtive nftId is not a valid asset. [weihao.zhang]
    }
}
