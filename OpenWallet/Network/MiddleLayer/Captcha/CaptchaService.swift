//
//  CaptchaService.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/20.
//

import Foundation
import Alamofire

class CaptchaService {
    let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetWorkManager()) {
        self.networkManager = networkManager
    }
    
    func captchaValidate(request: CaptchaValidateRequest) async throws -> ApiSuccessResponse<UserProfile?> {
        let task = networkManager.postRequest(
            ApiEndPoints.Captcha.captchaValidate,
            payload: request
        ).serializingDecodable(ApiSuccessResponse<UserProfile?>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    func sendCaptcha( _ request: CaptchaSendRequest) async throws -> ApiSuccessResponse<CaptchaSendResponse?> {
        OHLogInfo("request:\(request)")
        let task = networkManager.postRequest(
            ApiEndPoints.Captcha.captchaSend,
            payload: request
        )
        // .serializingString()
            .serializingDecodable(ApiSuccessResponse<CaptchaSendResponse?>.self)
        
        let result = try await networkManager.serializingDecodableTaskHandler(task)
        OHLogInfo(result)
        return result
    }
    
    // MARK: -
    // MARK: Find Username & Forgot Password Use
    @discardableResult
    private func sendEmailCaptcha(_ email: String, token: String, captchaScenario: CaptchaScenarioEnum) async throws -> ApiSuccessResponse<CaptchaSendResponse?> {
        switch captchaScenario {
        case .resetPassword, .forgetUsername, .register, .signIn:
            let  requestInput = CaptchaEmailSendRequest(
                emailAddress: email,
                captchaScenarioEnum: captchaScenario.rawValue,
                captchaTypeEnum: CaptchaTypeEnum.mailVerify.rawValue
            )
            OHLogInfo(requestInput)
            OHLogInfo(ApiEndPoints.Captcha.captchaSend)
            let task = networkManager.postRequest(
                ApiEndPoints.Captcha.captchaSend,
                payload: requestInput
            ).serializingDecodable(ApiSuccessResponse<CaptchaSendResponse?>.self)
            return try await networkManager.serializingDecodableTaskHandler(task)

        case .changePassword:
            let  requestInput = CaptchaEmailSendChangePasswordRequest(
                emailAddress: email, token: token,
                captchaScenarioEnum: captchaScenario.rawValue,
                captchaTypeEnum: CaptchaTypeEnum.mailVerify.rawValue
            )
            let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(User.shared.token)])
            let task = networkManager.postRequest(
                ApiEndPoints.Captcha.captchaSend,
                payload: requestInput,
                headers: headers
            ).serializingDecodable(ApiSuccessResponse<CaptchaSendResponse?>.self)
            return try await networkManager.serializingDecodableTaskHandler(task)

        }
    }
    
    @discardableResult
    private func sendSMSCaptcha(_ phoneNumber: String, _ phoneCountryCode: String, _ token: String, captchaScenario: CaptchaScenarioEnum) async throws -> ApiSuccessResponse<String?> {
        let requestInput = CaptchaSMSSendRequest(
            phoneCountryCode: phoneCountryCode,
            phoneNumber: phoneNumber,
            token: token,
            captchaScenarioEnum: captchaScenario.rawValue,
            captchaTypeEnum: CaptchaTypeEnum.smsVeyrif.rawValue
        )
        
        switch captchaScenario {
        case .resetPassword, .forgetUsername, .register, .signIn:
            let task = networkManager.postRequest(
                ApiEndPoints.Captcha.captchaSend,
                payload: requestInput
            ).serializingDecodable(ApiSuccessResponse<String?>.self)
            return try await networkManager.serializingDecodableTaskHandler(task)
        case .changePassword:
            let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(User.shared.token)])
            let task = networkManager.postRequest(
                ApiEndPoints.Captcha.captchaSend,
                payload: requestInput,
                headers: headers
            ).serializingDecodable(ApiSuccessResponse<String?>.self)
            return try await networkManager.serializingDecodableTaskHandler(task)
        }
    }
    
    @discardableResult
    private func verifyEmailCaptcha(_ email: String, _ captcha: String, _ token: String, captchaScenario: CaptchaScenarioEnum) async throws -> ApiSuccessResponse<String?> {
        switch captchaScenario {
        case .resetPassword, .forgetUsername, .register, .signIn:
            let requestInput = CaptchaEmailVerifyRequest(
                emailAddress: email,
                token: token,
                captcha: captcha,
                captchaScenarioEnum: captchaScenario.rawValue,
                captchaTypeEnum: CaptchaTypeEnum.mailVerify.rawValue
            )
            let task = networkManager.postRequest(
                ApiEndPoints.Captcha.captchaValidate,
                payload: requestInput
            ).serializingDecodable(ApiSuccessResponse<String?>.self)
            return try await networkManager.serializingDecodableTaskHandler(task)

        case .changePassword:
            let requestInput = CaptchaEmailVerifyChangePasswordRequest(
                captcha: captcha,
                token: token,
                captchaScenarioEnum: captchaScenario.rawValue,
                captchaTypeEnum: CaptchaTypeEnum.mailVerify.rawValue
            )
            let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(User.shared.token)])
            
            let task = networkManager.postRequest(
                ApiEndPoints.Captcha.captchaValidate,
                payload: requestInput,
                headers: headers
            ).serializingDecodable(ApiSuccessResponse<String?>.self)
            return try await networkManager.serializingDecodableTaskHandler(task)
        }
    }

    //  only Find username Use
    @discardableResult
    private func verifySMSCaptchaAndReturnUsername(_ phoneNumber: String, _ phoneCountryCode: String, _ token: String, _ captcha: String) async throws -> ApiSuccessResponse<FindUsernameSMSVerifyResponse?> {
        let requestInput = CaptchaSMSVerifyRequest(
            phoneCountryCode: phoneCountryCode,
            phoneNumber: phoneNumber,
            token: token,
            captchaScenarioEnum: CaptchaScenarioEnum.forgetUsername.rawValue,
            captchaTypeEnum: CaptchaTypeEnum.smsVeyrif.rawValue,
            captcha: captcha
        )
        let task = networkManager.postRequest(
            ApiEndPoints.Captcha.captchaValidate,
            payload: requestInput
        ).serializingDecodable(ApiSuccessResponse<FindUsernameSMSVerifyResponse?>.self)
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    @discardableResult
    private func verifySMSCaptcha(email: String, token: String, captcha: String, captchaScenario: CaptchaScenarioEnum, captchaType: CaptchaTypeEnum) async throws -> ApiSuccessResponse<String?> {
        switch captchaScenario {
        case .resetPassword, .forgetUsername, .register, .signIn:
            let requestInput = CaptchaSMSVerifyResetPasswordRequest(
                emailAddress: email,
                captcha: captcha,
                token: token,
                captchaScenarioEnum: captchaScenario.rawValue,
                captchaTypeEnum: captchaType.rawValue)
            let task = networkManager.postRequest(
                ApiEndPoints.Captcha.captchaValidate,
                payload: requestInput
            ).serializingDecodable(ApiSuccessResponse<String?>.self)
            return try await networkManager.serializingDecodableTaskHandler(task)
        case .changePassword:
            let requestInput = CaptchaSMSVerifyChangePasswordRequest(
                captcha: captcha,
                token: token,
                captchaScenarioEnum: captchaScenario.rawValue,
                captchaTypeEnum: captchaType.rawValue)
            let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(User.shared.token)])
            
            let task = networkManager.postRequest(
                ApiEndPoints.Captcha.captchaValidate,
                payload: requestInput,
                headers: headers
            ).serializingDecodable(ApiSuccessResponse<String?>.self)
            return try await networkManager.serializingDecodableTaskHandler(task)
        }
    }
    
}

// MARK: -
// MARK: Find Username & Forgot Password Use
extension CaptchaService {
    func trySendingEmailCaptcha(_ email: String, token: String, captchaScenario: CaptchaScenarioEnum) async throws -> ApiSuccessResponse<CaptchaSendResponse?> {
        let respone = try await sendEmailCaptcha(email, token: token, captchaScenario: captchaScenario)
        OHLogInfo(respone)
        return respone
    }
    
    func tryVerifyEmailCaptcha(_ email: String, _ captcha: String, _ token: String, captchaScenario: CaptchaScenarioEnum) async throws -> (Bool, String) {
        let respone = try await verifyEmailCaptcha(email, captcha, token, captchaScenario: captchaScenario)
        OHLogInfo(respone)
        return (respone.status, respone.message)
    }
    
    func trySendingSMSCaptcha(_ phoneNumber: String, _ phoneCountryCode: String, _ token: String, captchaScenario: CaptchaScenarioEnum) async throws -> (Bool, String) {
        let respone = try await sendSMSCaptcha(phoneNumber, phoneCountryCode, token, captchaScenario: captchaScenario)
        OHLogInfo(respone)
        return (respone.status, respone.message)
    }
    
    func tryVerifySMSCaptchaAndReturnUsername(_ phoneNumber: String, _ phoneCountryCode: String, _ token: String, _ captcha: String) async throws -> (String?, String ) {
        let respone = try await verifySMSCaptchaAndReturnUsername(phoneNumber, phoneCountryCode, token, captcha)
        OHLogInfo(respone)
        return (respone.data?.username, respone.message)
    }
    
    // Forgot Password Use
    func tryVerifySMSCaptcha(_ email: String, _ token: String, _ captcha: String, captchaScenario: CaptchaScenarioEnum, captchaType: CaptchaTypeEnum) async throws -> (Bool, String) {
        let respone = try await verifySMSCaptcha(email: email,
                                                 token: token,
                                                 captcha: captcha,
                                                 captchaScenario: captchaScenario,
                                                 captchaType: captchaType)
        OHLogInfo(respone)
        return (respone.status, respone.message)
    }
    
}
