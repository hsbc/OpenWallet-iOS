//
//  ERC721TokenRequest.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/21.
//

import Foundation

struct ERC721TokenRequest: Encodable {
    var accountId: String
    var contractAddress: String
}

// Don't need to pass value now ，leave it empty for future expansion
struct ContractRequest: Encodable {
    
}
