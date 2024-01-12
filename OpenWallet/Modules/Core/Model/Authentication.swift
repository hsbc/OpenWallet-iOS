//
//  Authentication.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 5/26/22.
//

import Foundation

class Authentication: ObservableObject {
    @Published var isValidated = false
    
    func updateValidation(success: Bool) {
        isValidated = success
    }
}
