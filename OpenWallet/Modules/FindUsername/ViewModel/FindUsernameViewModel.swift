//
//  FindUsernameViewModel.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/21.
//

import Foundation
import SwiftUI

@MainActor
class FindUsernameViewModel: ObservableObject {
    
    @Published var captcha: String = ""
    @Published var username: String = ""
    @Published var email: String = ""
    
    @Published var secretToken: String = "" // the token in body for this flow

    @Published var toastErrorMessageForPhoneVerification: String = AppState.defaultErrorMesssage
    @Published var apiErrorMessageForPhoneVerification: String = ""
    
    @Published var toastErrorMessageForEmailVerification: String = AppState.defaultErrorMesssage
    @Published var apiErrorMessageForEmailVerification: String = ""
    
    @Published var isSendingCodeToEmail: Bool = false
    @Published var isSendingCodeToPhone: Bool = false

    @Published var showEmailVerification: Bool = false
    @Published var showPhoneVerification: Bool = false
    
    let captchaService: CaptchaService
    
    init(captchaService: CaptchaService = CaptchaService()) {
        self.captchaService = captchaService
    }
    
    // API request flow
    
    func checkEmailAddressAndSendCaptchaToEmail(_ email: String) async {
        do {
            isSendingCodeToEmail = true
            let respone = try await captchaService.trySendingEmailCaptcha(email, token: secretToken, captchaScenario: .forgetUsername)
            if let newToken = respone.data?.token, respone.status {
                secretToken = newToken
            } else {
                toastErrorMessageForEmailVerification = AppState.defaultErrorMesssage
            }
            OTPManager.shared.checkEmailVerifyLimit(email, message: respone.message)
            isSendingCodeToEmail = false
        } catch let apiErrorResponse as ApiErrorResponse {
            OHLogInfo(apiErrorResponse)
            toastErrorMessageForEmailVerification = apiErrorResponse.message ?? AppState.defaultErrorMesssage
            isSendingCodeToEmail = false
        } catch {
            OHLogInfo(error)
            toastErrorMessageForEmailVerification = AppState.defaultErrorMesssage
            isSendingCodeToEmail = false
        }
    }
    
    func verifyEmailCaptcha(_ email: String, _ captcha: String) async ->Bool {
        do {
            let (success, message) = try await captchaService.tryVerifyEmailCaptcha(email, captcha, secretToken, captchaScenario: .forgetUsername)
            OTPManager.shared.checkEmailVerifyLimit(email, message: message)
            if !success {
                apiErrorMessageForEmailVerification = message
                return false
            }
            return success
        } catch let apiErrorResponse as ApiErrorResponse {
            apiErrorMessageForEmailVerification = "\(apiErrorResponse.message ?? AppState.defaultErrorMesssage)"
            return false
        } catch {
            apiErrorMessageForEmailVerification = AppState.defaultErrorMesssage
            return false
        }
    }
    
    func sendPhoneCaptcha(_ phoneNumber: String, _ phoneCountryCode: String) async {
        do {
            isSendingCodeToPhone = true
            let (success, message) = try await captchaService.trySendingSMSCaptcha(phoneNumber, phoneCountryCode, secretToken, captchaScenario: .forgetUsername)
            if !success {
                toastErrorMessageForPhoneVerification = AppState.defaultErrorMesssage
            }
            OTPManager.shared.checkSmsVerifyLimit(email, message: message)
            isSendingCodeToPhone = false
        } catch let apiErrorResponse as ApiErrorResponse {
            OHLogInfo(apiErrorResponse)
            toastErrorMessageForPhoneVerification = apiErrorResponse.message ?? AppState.defaultErrorMesssage
            isSendingCodeToPhone = false
        } catch {
            toastErrorMessageForPhoneVerification = AppState.defaultErrorMesssage
            isSendingCodeToPhone = false
        }
        
    }
    func verifyPhoneCaptchaAndGetUarname(_ phone: String, _ countryCode: String, _ captcha: String) async -> Bool {
        
        do {
            let (name, message) = try await captchaService.tryVerifySMSCaptchaAndReturnUsername(phone, countryCode, secretToken, captcha)
            OTPManager.shared.checkSmsVerifyLimit(email, message: message)
            if let usernameFounded = name {
                username = usernameFounded
                return true
            } else {
                apiErrorMessageForPhoneVerification = message
                return false
            }
        } catch let apiErrorResponse as ApiErrorResponse {
            apiErrorMessageForPhoneVerification = "\(apiErrorResponse.message ?? AppState.defaultErrorMesssage)"
            return false
        } catch {
            apiErrorMessageForPhoneVerification = AppState.defaultErrorMesssage
            return false
        }
        
    }
    
}
