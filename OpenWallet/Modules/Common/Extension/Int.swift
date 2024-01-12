//
//  Int.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/28/22.
//

import Foundation

extension Int {
    
    /**
     Add repeating leading padding character to the value
     */
    func addLeadingPadding(_ paddingCharacter: String, _ desiredLength: Int) -> String {
        let count = numberOfDigits(self)
        
        if count < desiredLength {
            let paddingContent = String(repeating: paddingCharacter, count: desiredLength - count)
            return "\(paddingContent)\(self)"
        } else {
            return "\(self)"
        }
    }
    
    func numberOfDigits(_ number: Int) -> Int {
        if (number < 10 && number >= 0) || (number > -10 && number < 0) {
            return 1
        } else {
            return 1 + numberOfDigits(number / 10)
        }
    }
}
