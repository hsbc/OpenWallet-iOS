//
//  Array.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/14/22.
//

import Foundation

extension Array {
    /**
     Split array into chunks (i.e. array of array) by chunk size.
     */
    func chunk(_ size: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, self.count)])
        }
    }
}
