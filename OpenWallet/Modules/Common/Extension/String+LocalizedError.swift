//
//  String+LocalizedError.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 10/8/22.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
