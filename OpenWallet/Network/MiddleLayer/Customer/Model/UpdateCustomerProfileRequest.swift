//
//  UpdateCustomerProfileRequest.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/19/22.
//

import Foundation

struct UpdateCustomerProfileRequest: Encodable {
    let avatar: String?
    let marketingEnabled: Bool?
    
    init(avatar: String) {
        self.avatar = avatar
        self.marketingEnabled = nil
    }
    
    init(marketingEnabled: Bool) {
        self.avatar = nil
        self.marketingEnabled = marketingEnabled
    }
    
    init(avatar: String, marketingEnabled: Bool) {
        self.avatar = avatar
        self.marketingEnabled = marketingEnabled
    }
}
