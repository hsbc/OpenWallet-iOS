//
//  ApiSuccessResponse.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/20/22.
//

import Foundation

struct ApiSuccessResponse<T: Decodable>: Decodable {
    let status: Bool
    let message: String
    let data: T
}
