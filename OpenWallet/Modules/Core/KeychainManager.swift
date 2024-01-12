//
//  KeychainManager.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/21.
//

import Foundation
import Security
import UIKit

public enum KeychainServiceKey: String {
    case onlyUserName
    case userNameAndPassword
}
// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)
open class KeychainManager {
    
    public static func saveUserNameByBundleId(userName: String) {
        let status = KeychainManager.saveData(service: KeychainServiceKey.onlyUserName.rawValue, account: EnvironmentConfig.appBundleId, data: userName.toData())
        if status != 0 {
            OHLogInfo("saveUserNameByBundleId failed status = \(status)")
        }
    }
    
    public static func loadUserNameByBundleId() -> String? {
        if let receivedData = KeychainManager.loadData(service: KeychainServiceKey.onlyUserName.rawValue, account: EnvironmentConfig.appBundleId) {
            return receivedData.toString()
        } else {
            return nil
        }
    }
    
    public static func removeUserNameByBundleId() {
        let status = KeychainManager.removeData(service: KeychainServiceKey.onlyUserName.rawValue, account: EnvironmentConfig.appBundleId)
        if status != 0 {
            OHLogInfo("removeUserNameByBundleId failed status = \(status)")
        }
    }
    
    public static func updateData(service: String, account: String, data: Data) -> OSStatus {
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account],
                                                                     forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue])
        
        let status = SecItemUpdate(keychainQuery as CFDictionary, [kSecValueDataValue: data] as CFDictionary)
        
        // Always check the status
        if status != errSecSuccess {
            if let err = SecCopyErrorMessageString(status, nil) {
                OHLogInfo("Write failed: \(err)")
            }
        }
        return status
    }
    
    public static func removeData(service: String, account: String) -> OSStatus {
        
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account],
                                                                     forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue])
        
        // Delete any existing items
        let status = SecItemDelete(keychainQuery as CFDictionary)
        
        // Always check the status
        if status != errSecSuccess {
            if let err = SecCopyErrorMessageString(status, nil) {
                OHLogInfo("Remove failed: \(err)")
            }
        }
        return status
    }
    
    public static func saveData(service: String, account: String, data: Data) -> OSStatus {
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, data],
                                                                     forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        // Add the new keychain item
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            return KeychainManager.updateData(service: service, account: account, data: data)
        }
        
        // Always check the status
        else if status != errSecSuccess {
            if let err = SecCopyErrorMessageString(status, nil) {
                OHLogInfo("Write failed: \(err)")
            }
        }
        return status
    }
    
    public static func loadData(service: String, account: String) -> Data? {
        
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, kCFBooleanTrue!, kSecMatchLimitOneValue],
                                                                     forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef: AnyObject?
        
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: Data?
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = retrievedData
            }
        } else {
            OHLogInfo("Nothing was retrieved from the keychain. Status code \(status)")
        }
        
        return contentsOfKeychain
    }
}
