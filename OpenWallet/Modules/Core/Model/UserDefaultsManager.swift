//
//  UserDefaultsManager.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 10/13/22.
//

import Foundation

open class UserDefaultsManager {
    
    public static let isRememberedUsernameKey: String = "isRememberUsername"
    
    public static func setIsRememberedUsername(_ isRememberUsername: Bool) {
        setValueByKey(value: isRememberUsername, key: UserDefaultsManager.isRememberedUsernameKey)
    }

    public static func isRememberedUsername() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: UserDefaultsManager.isRememberedUsernameKey)
    }

    public static func setValueByKey(value: Any?, key: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
}
