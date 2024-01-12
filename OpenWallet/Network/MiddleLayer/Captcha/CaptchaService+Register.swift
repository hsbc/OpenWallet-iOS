//
//  CaptchaService+Register.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/26.
//

import Foundation
// MARK: Register fuction use
extension CaptchaService {
    @discardableResult
    private func registerSendEmailCaptcha(username: String, email: String, token: String) async throws -> ApiSuccessResponse<CaptchaSendResponse?> {
        let requestInput = RegisterCaptchaSendEmailRequest(
            username: username,
            token: token,
            emailAddress: email,
            captchaScenarioEnum: CaptchaScenarioEnum.register.rawValue,
            captchaTypeEnum: CaptchaTypeEnum.mailVerify.rawValue
        )
        OHLogInfo(requestInput)
        let task = networkManager.postRequest(
            ApiEndPoints.Captcha.captchaSend,
            payload: requestInput
        ).serializingDecodable(ApiSuccessResponse<CaptchaSendResponse?>.self)
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    @discardableResult
    private func registerVerifyEmailCaptcha(username: String, captcha: String, token: String) async throws -> ApiSuccessResponse<String?> {
        let requestInput = RegisterCaptchaValidateRequest(
            username: username,
            captcha: captcha,
            token: token,
            captchaScenarioEnum: CaptchaScenarioEnum.register.rawValue,
            captchaTypeEnum: CaptchaTypeEnum.mailVerify.rawValue
        )
        OHLogInfo(requestInput)
        let task = networkManager.postRequest(
            ApiEndPoints.Captcha.captchaValidate,
            payload: requestInput
        ).serializingDecodable(ApiSuccessResponse<String?>.self)
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    @discardableResult
    private func registerSendSMSCaptcha(username: String, phoneNumber: String, phoneCountryCode: String, token: String) async throws -> ApiSuccessResponse<String?> {
        let requestInput = RegisterCaptchaSendSMSRequest(
            username: username,
            token: token,
            phoneCountryCode: phoneCountryCode,
            phoneNumber: phoneNumber,
            captchaScenarioEnum: CaptchaScenarioEnum.register.rawValue,
            captchaTypeEnum: CaptchaTypeEnum.smsVeyrif.rawValue
        )
        OHLogInfo(requestInput)
        let task = networkManager.postRequest(
            ApiEndPoints.Captcha.captchaSend,
            payload: requestInput
        ).serializingDecodable(ApiSuccessResponse<String?>.self)
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    @discardableResult
    private func registerVerifySMSCaptcha(username: String, token: String, captcha: String) async throws -> ApiSuccessResponse<String?> {
        let requestInput = RegisterCaptchaValidateRequest(
            username: username,
            captcha: captcha,
            token: token,
            captchaScenarioEnum: CaptchaScenarioEnum.register.rawValue,
            captchaTypeEnum: CaptchaTypeEnum.smsVeyrif.rawValue)
        OHLogInfo(requestInput)
        let task = networkManager.postRequest(
            ApiEndPoints.Captcha.captchaValidate,
            payload: requestInput
        ).serializingDecodable(ApiSuccessResponse<String?>.self)
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    // MARK: - Wrapper functions of Auth APIs
    func tryRegisterSendingEmailCaptcha(email: String, username: String, token: String) async throws -> (Bool, String) {
        let respone = try await registerSendEmailCaptcha(username: username, email: email, token: token)
        OHLogInfo(respone)
        return (respone.status, respone.message)
    }
    
    func tryRegisterVerifyEmailCaptcha(username: String, captcha: String, token: String) async throws ->(Bool, String) {
        let respone = try await registerVerifyEmailCaptcha(username: username, captcha: captcha, token: token)
        OHLogInfo(respone)
        return (respone.status, respone.message)
    }
    
    func tryRegisterSendingSMSCaptcha(username: String, phoneNumber: String, phoneCountryCode: String, token: String) async throws -> (Bool, String) {
        let respone = try await registerSendSMSCaptcha(username: username, phoneNumber: phoneNumber, phoneCountryCode: phoneCountryCode, token: token)
        OHLogInfo(respone)
        return (respone.status, respone.message)
    }
    
    func tryRegisterVerifySMSCaptcha(username: String, captcha: String, token: String) async throws ->(Bool, String) {
        let respone = try await registerVerifySMSCaptcha(username: username, token: token, captcha: captcha)
        OHLogInfo(respone)
        return (respone.status, respone.message)
    }
    
}
