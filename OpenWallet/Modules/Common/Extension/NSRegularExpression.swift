//
//  NSRegularExpression.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/13/22.
//

import Foundation

extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
    
    /**
     Test if string match the regular expression
     */
    func test(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
    
    func getNumberOfCount(_ string: String) -> Int {
        let range = NSRange(location: 0, length: string.utf16.count)
        return numberOfMatches(in: string, options: [], range: range)
    }
}
