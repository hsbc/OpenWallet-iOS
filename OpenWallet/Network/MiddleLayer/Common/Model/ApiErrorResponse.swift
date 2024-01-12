//
//  ApiErrorResponse.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/4/22.
//

import Foundation

struct ApiErrorResponse: Decodable, Error {
    let message: String?
    let status: Bool?
    let data: String?
    
    init(message: String?, status: Bool?, data: String?) {
        self.message = message
        self.status = status
        self.data = data
    }

}
