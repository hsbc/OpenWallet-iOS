//
//  RegisterViewModel.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/26.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var showUsernameApiError: Bool = false
    @Published var showUsernameAcceptanceCriteriaInfo: Bool = false
    @Published var isCurrentEmailVerified: Bool = false
    @Published var showPassword: Bool = false
    @Published var showConfirmPassword: Bool = false
    @Published var showPasswordTips: Bool = false
    @Published var showPasswordApiError: Bool = false
    @Published var passwordTips = "Password must be 8-20 characters, includes at least three of the four types: upper/lower letters, number or symbols."
    @Published var showPasswordConfirmationError: Bool = false
    @Published var passwordConfirmationErrorMessage = "Password confirmation doesn't match."
    @Published var queuePosition: Int = 0
    @Published var phoneNum: String = ""
    @Published var countryCode = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var email: String = ""
    @Published var secretToken: String = "" // the token in body for this flow
    @Published var isInvalidPassword: Bool = false
    @Published var isInvalidConfirmPassword: Bool = false
    
    @Published var showEmailOTPVerification: Bool = false
    @Published var showSMSOTPVerification: Bool = false
    
    @Published var showEmailNotAcceptableError: Bool = false
    @Published var notAcceptatbleEmailAddressErrorMessage: String = "Please enter a valid email address."
    @Published var otherEmailAddressErrrorMessage: String?
    @Published var step: Int = 3
    @Published var backToEmailRegister: Bool = false
    @Published var registerFlowApiErrorMessage: String = ""
    @Published var showRegisterApiErrorMessage: Bool = false
    @Published var showCommonErrorToast: Bool = false
    @Published var isCallingTAndCApi: Bool = false
    
    // timeout popup
    @Published var popupSettings: PopUpSettings = PopUpSettings(title: "Timeout notification", messages: ["Your session has expired due to timed out."], buttonText: "Got it")
    @Published var showPopup: Bool = false
    @Published var showPopupAtVerifyView: Bool = false
    
    var passwordsAreReady: Bool {
        let isReady = password == confirmPassword && password.isAcceptablePassword && confirmPassword.isAcceptablePassword
        return isReady
    }
    
    let authService: AuthService
    let captchaService: CaptchaService
    let customerService: CustomerService
    
    init(captchaService: CaptchaService = CaptchaService(), customerService: CustomerService = CustomerService(), authService: AuthService = AuthService()) {
        self.captchaService = captchaService
        self.customerService = customerService
        self.authService = authService
    }
    
    @MainActor
    func registerUsername() async {
        do {
            let (token, message) = try await customerService.tryRegisterUsername(username: username)
            
            if let responseToken = token {
                secretToken = responseToken
                showUsernameApiError = false
            } else {
                registerFlowApiErrorMessage = message
                showUsernameApiError = true
                if message.contains(ERRCODE_EXCEED_TIME_LIMIT) {
                    showPopup = true
                }
            }
        } catch let apiErrorResponse as ApiErrorResponse {
            showUsernameApiError = true
            registerFlowApiErrorMessage = "\(apiErrorResponse.message ?? AppState.defaultErrorMesssage)"
            guard let message = apiErrorResponse.message else {
                return
            }
            if message.contains(ERRCODE_EXCEED_TIME_LIMIT) {
                showPopup = true
            }
        } catch {
            await MainActor.run {
                showUsernameApiError = true
                registerFlowApiErrorMessage = AppState.defaultErrorMesssage
            }
        }
    }
    
    @MainActor
    func registerPassword() async {
        do {
            let (isAvailable, message) = try await customerService.tryRegisterPassword(username: username,
                                                                                       password: password,
                                                                                       token: secretToken)
            if !isAvailable {
                showPasswordApiError = true
                registerFlowApiErrorMessage = message
                if message.contains(ERRCODE_EXCEED_TIME_LIMIT) {
                    showPopup = true
                }
            }
        } catch let apiErrorResponse as ApiErrorResponse {
            showPasswordApiError = true
            registerFlowApiErrorMessage = "\(apiErrorResponse.message ?? AppState.defaultErrorMesssage)"
            guard let message = apiErrorResponse.message else {
                return
            }
            if message.contains(ERRCODE_EXCEED_TIME_LIMIT) {
                showPopup = true
            }
        } catch {
            showPasswordApiError = true
            registerFlowApiErrorMessage = AppState.defaultErrorMesssage
        }
    }
    
    @MainActor
    func sendCaptchaToEmail() async -> Bool {
        do {
            let (isAvailable, message) = try await captchaService.tryRegisterSendingEmailCaptcha(email: email,
                                                                                                  username: username,
                                                                                                  token: secretToken)
            
            OTPManager.shared.checkEmailVerifyLimit(email, message: message)
            if !isAvailable && message.contains(ERRCODE_EXCEED_TIME_LIMIT) {
                showPopup = true
            }
            
        } catch let apiErrorResponse as ApiErrorResponse {
            if let message = apiErrorResponse.message, message.contains(ERRCODE_EXCEED_TIME_LIMIT) {
                showPopup = true
            }
        } catch {
        }
        // didn't show any error message for this API / when user click send code,show verify view directly
        return true
    }
    
    @MainActor
    func validateEmailCaptcha(_ email: String, _ captcha: String) async -> Bool {
        do {
            let (success, message) = try await captchaService.tryRegisterVerifyEmailCaptcha(username: username,
                                                                                            captcha: captcha,
                                                                                            token: secretToken)
            OTPManager.shared.checkEmailVerifyLimit(email, message: message)
            if !success {
                showRegisterApiErrorMessage = true
                registerFlowApiErrorMessage = message
                
                if message.contains(ERRCODE_EXCEED_TIME_LIMIT) {
                    showPopupAtVerifyView = true
                }
                return false
            }
            showRegisterApiErrorMessage = false
            return success
            
        } catch let apiErrorResponse as ApiErrorResponse {
            showRegisterApiErrorMessage = true
            
            guard let message = apiErrorResponse.message else {
                return false
            }
            if message.contains(ERRCODE_EXCEED_TIME_LIMIT) {
                showPopupAtVerifyView = true
            }
            
            registerFlowApiErrorMessage = "\(apiErrorResponse.message ?? AppState.defaultErrorMesssage)"
            return false
        } catch {
            showRegisterApiErrorMessage = true
            registerFlowApiErrorMessage = AppState.defaultErrorMesssage
            return false
        }
    }
    
    @MainActor
    func sendCaptchaToPhone() async -> Bool {
        do {
            let (isAvailable, message) = try await captchaService.tryRegisterSendingSMSCaptcha(username: username,
                                                                                               phoneNumber: phoneNum,
                                                                                               phoneCountryCode: countryCode, token: secretToken)
            OTPManager.shared.checkSmsVerifyLimit(email, message: message)
            if !isAvailable && message.contains(ERRCODE_EXCEED_TIME_LIMIT) {
                showPopup = true
            }
            
        } catch let apiErrorResponse as ApiErrorResponse {
            if let message = apiErrorResponse.message, message.contains(ERRCODE_EXCEED_TIME_LIMIT) {
                showPopup = true
            }
        } catch {
        }
        return true
    }
    
    @MainActor
    func validatePhoneCaptcha(_ captcha: String) async -> Bool {
        do {
            
            let (success, message) = try await captchaService.tryRegisterVerifySMSCaptcha(username: username,
                                                                                          captcha: captcha,
                                                                                          token: secretToken)
            OTPManager.shared.checkSmsVerifyLimit(email, message: message)
            if !success {
                showRegisterApiErrorMessage = true
                registerFlowApiErrorMessage = message
                
                if message.contains(ERRCODE_EXCEED_TIME_LIMIT) {
                    showPopupAtVerifyView = true
                }
                return false
            }
            showRegisterApiErrorMessage = false
            return success
            
        } catch let apiErrorResponse as ApiErrorResponse {
            showRegisterApiErrorMessage = true
            
            guard let message = apiErrorResponse.message else {
                return false
            }
            if message.contains(ERRCODE_EXCEED_TIME_LIMIT) {
                showPopupAtVerifyView = true
            }
            
            registerFlowApiErrorMessage = "\(apiErrorResponse.message ?? AppState.defaultErrorMesssage)"
            return false
        } catch {
            showRegisterApiErrorMessage = true
            registerFlowApiErrorMessage = AppState.defaultErrorMesssage
            return false
        }
    }
    
    @MainActor
    func registerUser() async -> Bool {
        isCallingTAndCApi = true
        do {
            let (isAvailable, message) = try await customerService.tryRegisterUser(username: username,
                                                                                   token: secretToken)
            isCallingTAndCApi = false
            if !isAvailable && message.contains(ERRCODE_EXCEED_TIME_LIMIT) {
                showPopup = true
            }
            return isAvailable
        } catch let apiErrorResponse as ApiErrorResponse {
            isCallingTAndCApi = false
            guard let message = apiErrorResponse.message else {
                return false
            }
            if message.contains(ERRCODE_EXCEED_TIME_LIMIT) {
                showPopup = true
            }
            return false
        } catch {
            isCallingTAndCApi = false
            return false
        }
    }
}

extension RegisterViewModel {
    @MainActor
    func fetchPosition() async {
        do {
            queuePosition = try await authService.fetchPosition(email)
        } catch {
            // timeout or network error
            queuePosition = -99
        }
    }
    
    func isEmailWithCorrectFormat() async -> Bool {
        if email.isEmail {
            return true
        } else {
            otherEmailAddressErrrorMessage = "Please enter a valid email address."
            return false
        }
    }
    
    func isConfirmPasswordFormatCorrectAndSameAsPassword() -> Bool {
        if confirmPassword.isAcceptablePassword && confirmPassword == password {
            showPasswordConfirmationError = false
            isInvalidConfirmPassword = false
            return true
        } else {
            showPasswordConfirmationError = true
            isInvalidConfirmPassword = true
            return false
        }
    }

}
