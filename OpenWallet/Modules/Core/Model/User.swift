//
//  User.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 5/25/22.
//

import Foundation

class User: ObservableObject {
    static let shared = User()
    
    @Published var id: String = ""
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var type: String = ""
    @Published var roles: [String] = []
    @Published var refreshToken: String = ""
    @Published var token: String = ""
    @Published var exptime: Int = 0
    @Published var isRenewingToken: Bool = false
    
    @Published var phoneCountryCodeList: [CountryCodeModel] = []
    @Published var phoneCountryCode: String = ""
    @Published var phoneNumber: String = ""
    @Published var profileImage: String = ""
    @Published var defaultProfileImage: String = "avatar_0"

    @Published var isLoggin: Bool = false
    
    @Published var hasWonLuckyDraw: Bool = false
    
    @Published var remindExpiringToken: Bool = false
    @Published var disableRemindExpiringToken: Bool = false
    
    func setUser(
        id: String,
        token: String,
        refreshToken: String,
        type: String
    ) {
        self.id = id
        self.token = token
        self.refreshToken = refreshToken
        self.type = type
        
        self.disableRemindExpiringToken = false
        self.isLoggin = true
    }
    
    func setUserProfile(_ customerProfile: CustomerProfile) {
        self.name = customerProfile.username
        self.email = customerProfile.emailAddress
        self.phoneCountryCode = customerProfile.phoneCountryCode
        self.phoneNumber = customerProfile.phoneNumber
        self.profileImage = customerProfile.avatar
        self.roles = customerProfile.roles
    }
    
    @MainActor
    func clearUser() {
        self.id = ""
        self.name = ""
        self.email = ""
        self.type = ""
        self.roles = []
        self.token = ""
        self.refreshToken = ""
        
        self.phoneCountryCode = ""
        self.phoneNumber = ""
        self.profileImage = ""

        self.isLoggin = false
        self.hasWonLuckyDraw = false
    }

    @MainActor
    @discardableResult
    func logoutUser() async -> Bool {
        guard isLoggin && !token.isEmpty else { return false }
        
        let authService = AuthService()
        var logoutSuccessfully: Bool = true
        
        do {
            try await authService.logout(token)
        } catch {
            OHLogInfo("Failed to log out user.")
            OHLogInfo(error)
            logoutSuccessfully = false
        }

        await MainActor.run {
            clearUser()
        }
        
        return logoutSuccessfully
    }
    
    func handlePersistedUserInfo() {
        // If remember username setting is not specified or is false but username has been stored in Keychain,
        // remove previously stored username from Keychain. [weihao.zhang]
        OHLogInfo("UserDefaultsManager.isRememberedUsername: \(UserDefaultsManager.isRememberedUsername())")
        
        if KeychainManager.loadUserNameByBundleId() != nil && !UserDefaultsManager.isRememberedUsername() {
            OHLogInfo("removeUserNameByBundleId")
            KeychainManager.removeUserNameByBundleId()
        }
    }
    
    @MainActor
    @discardableResult
    func fetchCountryCode() async -> [CountryCodeModel] {
        if phoneCountryCodeList.count > 0 {
            return phoneCountryCodeList
        }
        do {
            phoneCountryCodeList = try await AuthService().getCountryCodeInfo()
        } catch let error {
            OHLogInfo("fetchCountryCode error:\(error)")
        }
        return phoneCountryCodeList
    }
    
    func enableRenewAccessToken() -> Bool {
        let now: Int = Int(NSDate().timeIntervalSince1970)
        let enable: Bool = exptime > now
        return enable
    }
    
    @MainActor
    func checkIfShouldRenewAccessToken() {
        guard isLoggin && !token.isEmpty && exptime > 0 && !isRenewingToken else {
            return
        }
        if !enableRenewAccessToken() {
            return
        }
        
        let now: Int = Int(NSDate().timeIntervalSince1970)
        let flag: Bool = exptime - now < 60 * 5
        
        if flag {
            Task { @MainActor in
                if isRenewingToken {
                    return
                }
                isRenewingToken = true
                OHLogInfo("checkIfShouldRenewAccessToken begin renew accessToken")
                await User.shared.refreshToken()
            }
        }
    }
    
    @MainActor
    func refreshToken() async {
        guard isLoggin && !token.isEmpty && exptime > 0 else {
            return
        }
        
        let authService = AuthService()
        var newAccessToken: String = ""
        do {
            let response = try await authService.accessTokenRefresh(refreshToken)
            let responseData = response.data
            
            guard let rt = responseData?.token else {
                OHLogInfo("checkIfShouldRenewAccessToken accessToken failed")
                return
            }
            
            newAccessToken = rt
        } catch {
            OHLogInfo("checkIfShouldRenewAccessToken accessToken failed \(error)")
            OHLogInfo(error)
        }
        
        if newAccessToken.count > 0 {
            OHLogInfo("checkIfShouldRenewAccessToken accessToken success \(newAccessToken)")
            User.shared.token = newAccessToken
            
            do {
                let jwt = try UtilHelper().decode(jwtToken: newAccessToken)
                let exptime = jwt["exp"] as? Int ?? 0
                if exptime > 0 {
                    User.shared.exptime = exptime
                    OHLogInfo("checkIfShouldRenewAccessToken accessToken jwt decode success, exptime: \(exptime)")
                }
            } catch {
                OHLogInfo("checkIfShouldRenewAccessToken jwt decode failed \(error)")
                OHLogInfo(error)
            }
        }
        isRenewingToken = false
    }
}
