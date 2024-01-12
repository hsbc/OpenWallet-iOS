//
//  PasswordViewModel.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/26/22.
//

import Foundation
import SwiftUI

@MainActor
class PasswordViewModel: ObservableObject {
    @Published var email: String = User.shared.email
    @Published var isEmailVerified: Bool = false
    
    @Published var captcha: String = ""
    @Published var showEmailCaptchaVerification: Bool = false
    @Published var showPhoneCaptchaVerification: Bool = false
    
    @Published var isLoggingOn: Bool = false
    
    // Navigation isActive controllers
    @Published var showEmailVerificationStep: Bool = false
    
    @Published var showEmailNotAcceptableError: Bool = false
    @Published var otherEmailAddressErrrorMessage: String?
    
    @Published var showCurrentPassword: Bool = false
    @Published var showNewPassword: Bool = false
    @Published var showConfirmPassword: Bool = false

    @Published var showPasswordTips: Bool = false
    @Published var showPasswordConfirmationError: Bool = false

    @Published var isInvalidCurrentPassword: Bool = false
    @Published var isInvalidNewPassword: Bool = false
    @Published var isInvalidConfirmPassword: Bool = false
    
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var showPasswordRule: Bool = false
    @Published var passwordTips = "Password must be 8-20 characters, includes at least three of the four types: upper/lower letters, number or symbols."
    @Published var passwordConfirmationErrorMessage = "Password does not match."
    
    @Published var passwordErrorMessage: String = AppState.defaultErrorMesssage
    
    @Published var disableLogOnButton: Bool = true
    
    @Published var navigateToVerificationStep: Bool = false
    
    @Published var secretToken: String = "" // the token in body for this flow
    
    // change /reset password use different endpoint,but use one "EnterNewPasswordView" view, so use the same "resetPasswordSuccessfully" "isResettingPassword" "failedToResetPassword" to update UI
    @Published var resetPasswordSuccessfully: Bool = false
    @Published var isResettingPassword: Bool = false
    @Published var failedToResetPassword: Bool = false
    
    @Published var showCommonErrorToast: Bool = false
    @Published var toastErrorMessage: String = AppState.defaultErrorMesssage
    
    @Published var apiErrorMessage: String = ""
    
    @Published var navigateToErrorPage: Bool = false
    @Published var navigateToErrorPageFromEnteringNewPassword: Bool = false
    
    @Published var isSendingCaptcha: Bool = false

    let authService: AuthService
    let captchaService: CaptchaService
    
    init(authService: AuthService = AuthService(), captchaService: CaptchaService = CaptchaService()) {
        self.authService = authService
        self.captchaService = captchaService
    }
    
    var passwordsAreReady: Bool {
        let isReady = newPassword == confirmPassword && newPassword.isAcceptablePassword && confirmPassword.isAcceptablePassword
        return isReady
    }
    
    func getBarTitle(_ scenario: ChangePasswordScenario) -> String {
        switch scenario {
        case ChangePasswordScenario.changePassword:
            return "Change password"
        case ChangePasswordScenario.forgotPassword:
            return "Reset password"
        }
    }
    
    func getEnterPasswordStepInfoText(_ scenario: ChangePasswordScenario) -> String {
        switch scenario {
        case ChangePasswordScenario.changePassword:
            return "Enter new password"
        case ChangePasswordScenario.forgotPassword:
            return "Reset password"
        }
    }
    
    func getChangePasswordSuccessfullyMessage(_ scenario: ChangePasswordScenario) -> String {
        switch scenario {
        case ChangePasswordScenario.changePassword:
            return "You have successfully changed your password."
        case ChangePasswordScenario.forgotPassword:
            return "You have successfully reset your password."
        }
    }
    
    func clearPasswords() {
        // Clear states for passwords
        newPassword = ""
        confirmPassword = ""

        showNewPassword = false
        showConfirmPassword = false

        showPasswordTips = false
        showPasswordConfirmationError = false

        isInvalidNewPassword = false
        isInvalidConfirmPassword = false
    }
    
    func checkIfPasswordsAreConfirmed() {
        showPasswordConfirmationError = newPassword.count > 0 &&
        confirmPassword.count > 0 &&
        newPassword != confirmPassword
    }
}

extension PasswordViewModel {
    
    func sendEmailCaptcha(_ email: String, captchaScenario: CaptchaScenarioEnum) async {
        guard !isSendingCaptcha else { return }
        do {
            isSendingCaptcha = true
            let respone = try await captchaService.trySendingEmailCaptcha(email, token: secretToken, captchaScenario: captchaScenario)
            if let newToken = respone.data?.token, captchaScenario == .resetPassword {
                secretToken = newToken
                self.email = email
            }
            isSendingCaptcha = false
            OTPManager.shared.checkEmailVerifyLimit(User.shared.email, message: respone.message)
        } catch _ as ApiErrorResponse {
            isSendingCaptcha = false
        } catch {
            showCommonErrorToast = true
            toastErrorMessage = AppState.defaultErrorMesssage
            isSendingCaptcha = false
        }
    }
    
    func verifyEmailCaptcha(_ email: String, _ captcha: String, captchaScenario: CaptchaScenarioEnum) async throws -> Bool {
        do {
            let (success, message) = try await captchaService.tryVerifyEmailCaptcha(email, captcha, secretToken, captchaScenario: captchaScenario)
            OTPManager.shared.checkEmailVerifyLimit(User.shared.email, message: message)
            if !success {
                apiErrorMessage = message
                return false
            }
            apiErrorMessage = ""
            return success
        } catch let apiErrorResponse as ApiErrorResponse {
            apiErrorMessage = apiErrorResponse.message ?? AppState.defaultErrorMesssage
            return false
        } catch {
            apiErrorMessage = AppState.defaultErrorMesssage
            return false
        }
    }
    
    func sendSMSCaptcha(_ phoneNumber: String, _ phoneCountryCode: String, captchaScenario: CaptchaScenarioEnum) async {
        guard !isSendingCaptcha else { return }
        
        do {
            isSendingCaptcha = true
            let (_, message) = try await captchaService.trySendingSMSCaptcha(phoneNumber, phoneCountryCode, secretToken, captchaScenario: captchaScenario)
            isSendingCaptcha = false
            OTPManager.shared.checkSmsVerifyLimit(User.shared.email, message: message)
        } catch _ as ApiErrorResponse {
            isSendingCaptcha = false
        } catch {
            showCommonErrorToast = true
            toastErrorMessage = AppState.defaultErrorMesssage
            isSendingCaptcha = false
        }
    }
    
    func verifyPhoneCaptcha(_ phone: String, _ countryCode: String, _ captcha: String, captchaScenario: CaptchaScenarioEnum) async -> Bool {
        do {
            let (success, message) = try await captchaService.tryVerifySMSCaptcha(email, secretToken, captcha, captchaScenario: captchaScenario, captchaType: .smsVeyrif)
            OTPManager.shared.checkSmsVerifyLimit(User.shared.email, message: message)
            if !success {
                apiErrorMessage = message
                return false
            }
            apiErrorMessage = ""
            return success
        } catch let apiErrorResponse as ApiErrorResponse {
            apiErrorMessage = "\(apiErrorResponse.message ?? AppState.defaultErrorMesssage)"
            return false
        } catch {
            apiErrorMessage = AppState.defaultErrorMesssage
            return false
        }
    }
    
    func resetPassword() {
        // Should not trigger another resetting password process if the current one is ongoing. [weihao.zhang]
        guard !isResettingPassword else { return }
        guard passwordsAreReady else { return }
        
        Task {
            do {
                isResettingPassword = true
                resetPasswordSuccessfully = try await authService.tryResettingPasswordWithVerificationCode(email, newPassword, secretToken)
                if resetPasswordSuccessfully {
                    await logOutUser()
                } else {
                    failedToResetPassword = true
                }
                isResettingPassword = false
            } catch let apiErrorResponse as ApiErrorResponse {
                isResettingPassword = false
                failedToResetPassword = true
                OHLogInfo(apiErrorResponse)
            } catch {
                isResettingPassword = false
                navigateToErrorPageFromEnteringNewPassword = true
                OHLogInfo(error)
            }
        }
    }
    
    func isEmailWithCorrectFormat() async -> Bool {
        do {
            try await authService.infoCheckEmail(email)
        } catch let errorResponse as ApiErrorResponse {
            if errorResponse.message!.lowercased().contains("email format is not correct") {
                return false
            }
        } catch {
            otherEmailAddressErrrorMessage = "Unknown error."
            return false
        }
        return true
    }
}
// MARK: -
// MARK: only change passowrd use
extension PasswordViewModel {
    func changPasswordFirstFactor() async {
        do {
            isLoggingOn = true
            let response = try await authService.verifyFirstFactorChangePassword(currentPassword)
            isInvalidCurrentPassword = !response.status
            let responseData = response.data
            let token = responseData?.token
            
            guard !isInvalidCurrentPassword && responseData != nil && token != nil else {
                isLoggingOn = false
                disableLogOnButton = true
                passwordErrorMessage = response.message
                return
            }
            
            secretToken = token ?? ""
            isLoggingOn = false
            navigateToVerificationStep = true
        } catch let apiErrorResponse as ApiErrorResponse {
            isInvalidCurrentPassword = true
            isLoggingOn = false
            passwordErrorMessage = apiErrorResponse.message ?? AppState.defaultErrorMesssage
            disableLogOnButton = true
            OHLogInfo(apiErrorResponse)
        } catch {
            isInvalidCurrentPassword = true
            isLoggingOn = false
            disableLogOnButton = true
            navigateToErrorPage = true
            OHLogInfo(error)
        }
    }
    
    func changePassword() {
        guard !isResettingPassword else { return }
        guard passwordsAreReady && !User.shared.token.isEmpty else { return }
        
        Task {
            do {
                isResettingPassword = true
                resetPasswordSuccessfully = try await authService.tryChangePassword(newPassword, secretToken)
                if resetPasswordSuccessfully {
                    await logOutUser()
                } else {
                    failedToResetPassword = true
                }
                isResettingPassword = false
            } catch let apiErrorResponse as ApiErrorResponse {
                isResettingPassword = false
                failedToResetPassword = true
                OHLogInfo(apiErrorResponse)
            } catch {
                isResettingPassword = false
                navigateToErrorPageFromEnteringNewPassword = true
                OHLogInfo(error)
            }
        }
    }
    // notice：to avoid rootview navigate to welcome view
    private func logOutUser() async {
        Task { @MainActor in
            guard User.shared.isLoggin else { return }
            _ = try await authService.logout(User.shared.token)
            
            User.shared.clearUser()
        }
    }
    
}
