//
//  Phone.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/11/22.
//

import Foundation

struct PhoneNumber {
    var areaCode: String
    var number: String
}

extension PhoneNumber {
    func getMaskedForm() -> String {
        guard !self.areaCode.isEmpty && !self.number.isEmpty else {
            return ""
        }
        
        let rangeStart = self.number.startIndex
        let rangeEnd = self.number.index(self.number.startIndex, offsetBy: 6)
        let range = rangeStart..<rangeEnd
        return "+\(self.areaCode) \(number.maskSubrangeWithAsterisk(range: range))"
    }
}
