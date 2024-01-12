//
//  Int64.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/28/22.
//

import Foundation

extension Int64 {
    
    /**
     Use when datetime in mulliseconds are represented in Int64
     */
    func mullisecondsToMonthDayYear() -> String {
        // posted time is stored in milliseconds while TimeInterval is specified in seconds
        let timeIntervalInSeconds = TimeInterval(self / 1000)
        let date = Date(timeIntervalSince1970: timeIntervalInSeconds)
        return date.toMonthDayYearFormat
    }
    
    /**
     Add repeating leading padding character to the value
     */
    func addLeadingPadding(_ paddingCharacter: String, _ desiredLength: Int) -> String {
        let count = Int(self / 10 + 1)
        
        if count < desiredLength {
            let paddingContent = String(repeating: paddingCharacter, count: desiredLength - count)
            return "\(paddingContent)\(self)"
        } else {
            return "\(self)"
        }
    }
}
