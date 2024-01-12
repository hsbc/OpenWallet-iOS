//
//  LogonViewModel.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/26.
//

import Foundation
import UIKit

class LogonViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var userName: String = ""
    
    @Published var showUsernameHelp: Bool = false
    @Published var usernameHelpInfo: String = AppState.usernameHelpInfo
    
    @Published var isInvalidPassword: Bool = false
    @Published var showPasswordRule: Bool = false
    @Published var passwordRule: String = AppState.passwordRule
    @Published var passwordErrorMessage: String = AppState.defaultErrorMesssage
    @Published var disableLogOnButton: Bool = true
    
    @Published var isLoggingOn: Bool = false
    @Published var isRemember: Bool = false
    @Published var isLoading = false
    
    @Published var showSelectVerification: Bool = false
    @Published var firstFactorResponse: FirstFactorResponseData?
    
    @Published var showSendCaptchaWarning: Bool = false
    @Published var sendCaptchaErrorMessage: String = AppState.defaultErrorMesssage
    
    @Published var navigateToErrorPage: Bool = false
    // end
    
    let authService: AuthService
    let captchaService: CaptchaService
    let customerService: CustomerService
    let walletService: WalletService

    init(
        authService: AuthService = AuthService(),
        captchaService: CaptchaService = CaptchaService(),
        customerService: CustomerService = CustomerService(),
        walletService: WalletService = WalletService()
    ) {
        self.authService = authService
        self.captchaService = captchaService
        self.customerService = customerService
        self.walletService = walletService
    }
    
    @MainActor
    func verifyFirstFactor() async {
        do {
            isLoggingOn = true
            let response = try await authService.verifyFirstFactor(username: userName, password: password)
            isInvalidPassword = !response.status
            firstFactorResponse = response.data

            guard !isInvalidPassword && firstFactorResponse != nil else {
                isLoggingOn = false
                disableLogOnButton = true
                passwordErrorMessage = response.message
                return
            }

            isLoggingOn = false
            showSelectVerification = true
        } catch let apiErrorResponse as ApiErrorResponse {
            isInvalidPassword = true
            isLoggingOn = false
            passwordErrorMessage = apiErrorResponse.message ?? AppState.defaultErrorMesssage
            disableLogOnButton = true
            OHLogInfo(apiErrorResponse)
        } catch {
            isInvalidPassword = true
            isLoggingOn = false
            passwordErrorMessage = AppState.defaultErrorMesssage
            disableLogOnButton = true
            OHLogInfo(error)
        }
    }
    
    @MainActor
    func clearUsernameSettings() {
        // Clear user input username only if 'remember me' is turned off. [weihao.zhang]
        guard !isRemember else { return }
        userName = ""
    }
    
    @MainActor
    func clearPasswordSettings() {
        password = ""
        isInvalidPassword = false
        isLoggingOn = false
        disableLogOnButton = false
    }
    
    @MainActor
    func sendCaptchaToEmail() async {
        if firstFactorResponse == nil {
            showSendCaptchaWarning = true
            sendCaptchaErrorMessage = AppState.defaultErrorMesssage
            return
        }
        OHLogInfo("send to email!!")
        let request = CaptchaSendRequest(username: userName, token: firstFactorResponse!.token, captchaScenarioEnum: CaptchaScenarioEnum.signIn, captchaTypeEnum: CaptchaTypeEnum.mailVerify)
        do {
            let result = try await captchaService.sendCaptcha(request)
            OTPManager.shared.checkEmailVerifyLimit(firstFactorResponse!.maskedEmail, message: result.message)
        } catch _ as ApiErrorResponse {
            // do not need to do error handling when api return 4xx errors. [weihao.zhang]
        } catch {
            // display a popup-bar for 5xx errors. [weihao.zhang]
            showSendCaptchaWarning = true
            sendCaptchaErrorMessage = AppState.defaultErrorMesssage
        }
    }

    @MainActor
    func sendCaptchaToPhone() async {
        if firstFactorResponse == nil {
            showSendCaptchaWarning = true
            sendCaptchaErrorMessage = AppState.defaultErrorMesssage
            return
        }
        OHLogInfo("send to phone!!")
        let request = CaptchaSendRequest(username: userName, token: firstFactorResponse!.token, captchaScenarioEnum: CaptchaScenarioEnum.signIn, captchaTypeEnum: CaptchaTypeEnum.smsVeyrif)
        do {
            let result = try await captchaService.sendCaptcha(request)
            OTPManager.shared.checkSmsVerifyLimit(firstFactorResponse!.maskedEmail, message: result.message)
            // do not need to do error handling when api return 4xx errors. [weihao.zhang]
        } catch {
            // display a popup-bar for 5xx errors. [weihao.zhang]
            showSendCaptchaWarning = true
            sendCaptchaErrorMessage = AppState.defaultErrorMesssage
        }
    }
    
    @MainActor
    func doLoginRequest(signInedUser: UserProfile, customerProfile: CustomerProfile) async throws {
        User.shared.setUser(
            id: signInedUser.accountId,
            token: signInedUser.token,
            refreshToken: signInedUser.refreshToken,
            type: signInedUser.type
        )
        
        if !signInedUser.token.isEmpty {
            // {"iat": 1666256220, "sub": "abc", "exp": 1666256220}
            let jwt = try UtilHelper().decode(jwtToken: signInedUser.token)
            let exptime = jwt["exp"] as? Int ?? 0
            if exptime > 0 {
                User.shared.exptime = exptime
                OHLogInfo("User login accessToken exptime \(exptime)")
            }
            
            OHLogInfo("doLoginRequest \(jwt.description)")
        }
        
        User.shared.setUserProfile(customerProfile)
        updateUserNameToKeyChain(signInedUser.username)
    }
    
    private func updateUserNameToKeyChain(_ username: String) {
        UserDefaultsManager.setIsRememberedUsername(isRemember)

        if isRemember {
            KeychainManager.saveUserNameByBundleId(userName: username)
        } else {
            KeychainManager.removeUserNameByBundleId()
        }
    }
    
    func checkIfHaveUserNameInKeyChain() {
        isRemember = UserDefaultsManager.isRememberedUsername()
        
        // Only prepopulate username with the value in keychain when there is no username specified.
        // This is to handle navigate back from further steps. [weihao.zhang]
        if let userName = KeychainManager.loadUserNameByBundleId(), self.userName.isEmpty {
            self.userName = userName
        }
    }
}
