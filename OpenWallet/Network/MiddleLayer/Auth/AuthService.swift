//
//  AuthService.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/4/22.
//

import Alamofire
import Foundation

/**
 Auth APIs request methods
 */
class AuthService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetWorkManager()) {
        self.networkManager = networkManager
    }
    
    func verifyFirstFactor(username: String, password: String) async throws -> ApiSuccessResponse<FirstFactorResponseData?> {
        let request = LoginRequest(username: username, password: password)
        let task = networkManager.postRequest(
            ApiEndPoints.Auth.verifyFirstFactorLogin,
            payload: request
        ).serializingDecodable(ApiSuccessResponse<FirstFactorResponseData?>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }

    @discardableResult
    func signUp(emailAddress: String, username: String, password: String, verificationCode: String) async throws -> ApiSuccessResponse<String?> {
        let requestInput = RegisterRequest(
            emailAddress: emailAddress,
            password: password,
            username: username,
            verificationCode: verificationCode
        )
        let task = networkManager.postRequest(
            ApiEndPoints.Auth.signUp,
            payload: requestInput
        ).serializingDecodable(ApiSuccessResponse<String?>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }

    @discardableResult
    func infoCheckUsername(username: String) async throws -> ApiSuccessResponse<String?> {
        let infoToCheck = InfoCheckUsername(userName: username)
        let task = networkManager.postRequest(ApiEndPoints.Auth.infoCheckUsername, payload: infoToCheck)
            .serializingDecodable(ApiSuccessResponse<String?>.self)

        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    @discardableResult
    func infoCheckEmail(_ email: String) async throws -> ApiSuccessResponse<String?> {
        let infoToCheck = InfoCheckEmail(emailAddress: email)
        let task = networkManager.postRequest(ApiEndPoints.Auth.infoCheckEmail, payload: infoToCheck)
            .serializingDecodable(ApiSuccessResponse<String?>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    @discardableResult
    func captchaSendEmail(_ email: String) async throws -> ApiSuccessResponse<String?> {
        let requestInput = CaptchaSendEmail(email: email)
        let task = networkManager.postRequest(
            ApiEndPoints.Auth.captchaSendEmail,
            payload: requestInput,
            encoder: URLEncodedFormParameterEncoder(destination: .queryString)
        ).serializingDecodable(ApiSuccessResponse<String?>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    @discardableResult
    func captchaCheckEmail(_ email: String, _ captcha: String) async throws -> ApiSuccessResponse<String?> {
        let requestInput = CaptchaCheckForEmail(email: email, captcha: captcha)
        let task = networkManager.postRequest(ApiEndPoints.Auth.captchaCheckEmail, payload: requestInput)
            .serializingDecodable(ApiSuccessResponse<String?>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    @discardableResult
    func captchaDoubleCheckEmail(_ email: String, _ captcha: String) async throws -> ApiSuccessResponse<String> {
        let requestInput = CaptchaCheckForEmail(email: email, captcha: captcha)
        let task = networkManager.postRequest(ApiEndPoints.Auth.captchaDoubleCheckEmail, payload: requestInput)
            .serializingDecodable(ApiSuccessResponse<String>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    @discardableResult
    func changeEmailAddress(_ email: String, _ userToken: String) async throws -> ApiSuccessResponse<String?> {
        let requestInput = ChangeEmailAddress(emailAddress: email)
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let task = networkManager.putRequest(
            ApiEndPoints.Auth.changeEmailAddress,
            payload: requestInput,
            headers: headers
        ).serializingDecodable(ApiSuccessResponse<String?>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    @discardableResult
    func changeUserName(_ userName: String, _ userToken: String) async throws -> ApiSuccessResponse<String?> {
        let requestInput = ChangeUserName(userName: userName)
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let task = networkManager.putRequest(
            ApiEndPoints.Auth.changeUserName,
            payload: requestInput,
            headers: headers
        ).serializingDecodable(ApiSuccessResponse<String?>.self)

        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    @discardableResult
    func getAvatar(_ userToken: String) async throws -> String {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let task = networkManager.getRequest(
            ApiEndPoints.Auth.getAvatar,
            headers: headers
        ).serializingDecodable(ApiSuccessResponse<String?>.self)
        let response = try await networkManager.serializingDecodableTaskHandler(task)
    
        return response.message
    }
    
    @discardableResult
    func updateAvatar(_ avatar: String, _ userToken: String) async throws -> ApiSuccessResponse<String?> {
        let requestInput = UpdateAvatar(avatarName: avatar)
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let task = networkManager.putRequest(
            ApiEndPoints.Auth.updateAvatar,
            payload: requestInput,
            headers: headers
        ).serializingDecodable(ApiSuccessResponse<String?>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    @discardableResult
    func signIn(_ email: String, _ password: String) async throws -> UserProfile {
        let requestInput = SignInByEmail(email: email, password: password)
        let task = networkManager.postRequest(
            ApiEndPoints.Auth.signInEmail,
            payload: requestInput
        ).serializingDecodable(ApiSuccessResponse<UserProfile>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task).data
    }

    @discardableResult
    func logout(_ userToken: String) async throws -> ApiSuccessResponse<String?> {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let task = networkManager.postRequest(
            ApiEndPoints.Auth.logout,
            headers: headers
        ).serializingDecodable(ApiSuccessResponse<String?>.self)

        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    func accessTokenRefresh(_ refreshToken: String) async throws -> ApiSuccessResponse<RefreshTokenResponseData?> {
        let request = RefreshTokenRequest(refreshToken: refreshToken)
        let task = networkManager.postRequest(
            ApiEndPoints.Auth.accessTokenRefresh,
            payload: request
        ).serializingDecodable(ApiSuccessResponse<RefreshTokenResponseData?>.self)
        
        let response = try await networkManager.serializingDecodableTaskHandler(task)
        return response
    }
    
    @discardableResult
    func resetPassword(_ email: String, _ password: String, _ secretToken: String) async throws -> ApiSuccessResponse<String?> {
        let requestInput = ResetPasswordForEmail(email: email, newPassword: password, token: secretToken)
        let task = networkManager.postRequest(
            ApiEndPoints.Auth.resetPassword,
            payload: requestInput
        ).serializingDecodable(ApiSuccessResponse<String?>.self)

        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    @discardableResult
    func fetchPosition(_ email: String) async throws -> Int {
        let task = networkManager.getRequest(ApiEndPoints.Auth.queuePosition+"?email=\(email)").serializingDecodable(ApiSuccessResponse<Int>.self)

        return try await networkManager.serializingDecodableTaskHandler(task).data
    }
    
    func getCountryCodeInfo() async throws -> [CountryCodeModel] {
        let task = networkManager.getRequest(
            ApiEndPoints.Auth.getCountryCode
        ).serializingDecodable(ApiSuccessResponse<[CountryCodeModel]>.self)
        
        let response = try await networkManager.serializingDecodableTaskHandler(task)
        let customerBankInfo = response.data

        return customerBankInfo
    }
    
    // MARK: -
    // MARK: change password flow

    @discardableResult
    func changePassword(_ password: String, _ token: String) async throws -> ApiSuccessResponse<String?> {
        let requestInput = ChangePasswordRequest(password: password, token: token)
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(User.shared.token)])

        let task = networkManager.postRequest(
            ApiEndPoints.Auth.changePassword,
            payload: requestInput,
            headers: headers
        ).serializingDecodable(ApiSuccessResponse<String?>.self)

        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    func verifyFirstFactorChangePassword(_ password: String) async throws -> ApiSuccessResponse<FirstFactorChangePasswordResponse?> {
        let request = FirstFactorChangePasswordRequest(password: password)
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(User.shared.token)])
        let task = networkManager.postRequest(
            ApiEndPoints.Auth.verifyFirstFactorChangePassword,
            payload: request,
            headers: headers
        ).serializingDecodable(ApiSuccessResponse<FirstFactorChangePasswordResponse?>.self)
        let result = try await networkManager.serializingDecodableTaskHandler(task)
        return result
    }

}

/**
 Wrapper functions of Auth APIs
 */
extension AuthService {
    /**
     @Summary
     Check if a username is available
     
     @Return
     A Bool indicates if the username is available or not.
     */
    func isUsernameAvailable(_ username: String) async throws -> Bool {
        try await infoCheckUsername(username: username)
        let isAvailable: Bool = true // Status code (200-300) means success. Server returns othe status code will be thrown as error
        
        return isAvailable
    }
    
    /**
     @Summary
     Check if an email address is available
     
     @Return
     A Bool indicates if the email address is available or not.
     */
    func isEmailAvailable(_ email: String) async throws -> Bool {
        try await infoCheckEmail(email)
        let isAvailable: Bool = true // Status code (200-300) means success. Server returns othe status code will be thrown as error

        return isAvailable
    }
    
    /**
     @Summary
     Try sending captcha to email.
     
     @Return
     A Bool indicates if the captcha has been sent successfully.
     */
    func trySendingEmailCaptcha(_ email: String) async throws -> Bool {
        try await captchaSendEmail(email)
        let isCaptchaSentSuccessfully: Bool = true // Status code (200-300) means success. Server returns othe status code will be thrown as error

        return isCaptchaSentSuccessfully
    }
    
    /**
     @Summary
     Check if the email and captcha is valid/available.
     
     @Return
     A Bool indicates if the email and captcha is valid/available.
     */
    func isEmailCaptchaAvailable(_ email: String, _ captcha: String) async throws -> Bool {
        try await captchaCheckEmail(email, captcha)
        let isAvailable: Bool = true // Status code (200-300) means success. Server returns othe status code will be thrown as error

        return isAvailable
    }

    /**
     @Summary
     Check if the email and captcha are valid, get a new captcha if yes
     
     @Return
     A new captcha if the email and captcha is valid/available.
     */
    func checkEmailCaptchaAndGetNewCaptcha(_ email: String, _ captcha: String) async throws -> String {
        let response = try await captchaDoubleCheckEmail(email, captcha)
        let newCaptcha = response.data

        return newCaptcha
    }
    
    /**
     @ Summary
    Try update the user email address.
     
     @ Return
     Bool. If update email successfully, return true, otherwise, false.
     */
    func tryChangingEmailAddress(_ email: String, _ userToken: String) async throws -> Bool {
        try await changeEmailAddress(email, userToken)
        let updateSuccessfully: Bool = true // Status code (200-300) means success. Server returns othe status code will be thrown as error

        return updateSuccessfully
    }
    
    /**
     @ Summary
     Try changing username.
     
     @ Return
     Bool. True if change username successfully, otherwise, false.
     */
    func tryChangingUsername(_ username: String, _ userToken: String) async throws -> Bool {
        try await changeUserName(username, userToken)
        let updateSuccessfully: Bool = true // Status code (200-300) means success. Server returns othe status code will be thrown as error
        
        return updateSuccessfully
    }
    
    /**
     @ Summary
     Try changing the avatar.
     
     @ Return
     Bool. True if change avatar successfully, otherwise, false.
     */
    func tryChangingAvatar(_ avatar: String, _ userToken: String) async throws -> Bool {
        try await updateAvatar(avatar, userToken)
        let updateSuccessfully: Bool = true // Status code (200-300) means success. Server returns othe status code will be thrown as error
        
        return updateSuccessfully
    }
    
    /**
     @ Summary
     Try resetting the password with verification code.
     
     @ Return
     Bool. True if reset password successfully, otherwise, false.
     */
    @discardableResult
    func tryResettingPasswordWithVerificationCode(_ email: String, _ password: String, _ secretToken: String) async throws -> Bool {
        let respone = try await resetPassword(email, password, secretToken)
        return respone.status
    }
    
    /**
     @ Summary
     Try signning up an account
     
     @ Return
     Bool. True if sign up successfully, otherwise, false.
     */
    func trySigningUp(emailAddress: String, username: String, password: String, verificationCode: String) async throws -> Bool {
        try await signUp(emailAddress: emailAddress, username: username, password: password, verificationCode: verificationCode)
        let isSignUpSuccessfully = true // Status code (200-300) means success. Server returns othe status code will be thrown as error
        
        return isSignUpSuccessfully
    }

    // MARK: -
    // MARK: change password flow
    func tryChangePassword(_ password: String, _ token: String) async throws -> Bool {
        let respone = try await changePassword(password, token)
        return respone.status
    }
    
    func tryVerifyFirstFactorChangePassword(_ password: String) async throws -> String? {
        let respone = try await verifyFirstFactorChangePassword(password)
        return respone.data?.token
    }

}
