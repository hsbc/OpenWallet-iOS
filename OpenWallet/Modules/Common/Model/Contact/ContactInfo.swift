//
//  Contact.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/12/22.
//

import Foundation

/**
 Type for ContactInfo 'type'
 */
enum ContactType {
    case email
    case phoneNumber
}

/**
 Type for ContactInfo 'value'
 */
enum Contact {
    case email(String)
    case phoneNumber(PhoneNumber)
}

struct ContactInfo {
    var value: Contact
    var maskedAddress: String = ""
    var userName: String = ""
    var token: String = ""
}

extension ContactInfo {
    var type: ContactType {
        switch self.value {
        case .email:
            return ContactType.email
        case .phoneNumber:
            return ContactType.phoneNumber
        }
    }
    
    // return stringified format of the 'value'
    var stringifiedValue: String {
        switch self.value {
        case .email(let emailAddress):
            return emailAddress
        case .phoneNumber(let phone):
            return "+\(phone.areaCode) \(phone.number)"
        }
    }
    
    func getMaskedValue() -> String {
        if !maskedAddress.isEmpty {
            return maskedAddress
        }

        switch self.value {
        case .email(let emailAddress):
            return emailAddress.getMaskedFormEmail() // add value masking function here.
        case .phoneNumber(let phone):
            return phone.getMaskedForm()
        }
    }
}
