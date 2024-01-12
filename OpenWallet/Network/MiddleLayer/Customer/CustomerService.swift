//
//  CustomerService.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/19/22.
//

import Alamofire
import Foundation

/**
 Customer APIs request methods
 */
class CustomerService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetWorkManager()) {
        self.networkManager = networkManager
    }

    func validateEmail(_ email: String) async throws -> ApiSuccessResponse<String?> {
        let requestInput = EmailValidationRequest(email: email)

        let task = networkManager.postRequest(
            ApiEndPoints.Customer.validateEmail,
            payload: requestInput
        ).serializingDecodable(ApiSuccessResponse<String?>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }

    func validateUsername(_ username: String) async throws -> ApiSuccessResponse<String?> {
        let requestInput = UsernameValidationRequest(username: username)

        let task = networkManager.postRequest(
            ApiEndPoints.Customer.validateUsername,
            payload: requestInput
        ).serializingDecodable(ApiSuccessResponse<String?>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    func validatePhone(countryCode: String, phoneNumber: String) async throws -> ApiSuccessResponse<String?> {
        let requestInput = PhoneValidationRequest(countryCode: countryCode, phoneNumber: phoneNumber)
        
        let task = networkManager.postRequest(
            ApiEndPoints.Customer.validatePhone,
            payload: requestInput
        ).serializingDecodable(ApiSuccessResponse<String?>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    func validatePassword(_ password: String) async throws -> ApiSuccessResponse<String?> {
        let requestInput = PasswordValidationRequest(password: password)
        
        let task = networkManager.postRequest(
            ApiEndPoints.Customer.validatePassword,
            payload: requestInput
        ).serializingDecodable(ApiSuccessResponse<String?>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }

    func getProfile(_ userToken: String) async throws -> CustomerProfile {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let task = networkManager.getRequest(
            ApiEndPoints.Customer.getProfile,
            headers: headers
        ).serializingDecodable(ApiSuccessResponse<CustomerProfile>.self)
        let response = try await networkManager.serializingDecodableTaskHandler(task)
    
        return response.data
    }
    
    func updateProfile(_ requestInput: UpdateCustomerProfileRequest, _ userToken: String) async throws -> ApiSuccessResponse<CustomerProfile> {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let task = networkManager.postRequest(
            ApiEndPoints.Customer.updateProfile,
            payload: requestInput,
            headers: headers
        ).serializingDecodable(ApiSuccessResponse<CustomerProfile>.self)
        
        let response = try await networkManager.serializingDecodableTaskHandler(task)
    
        return response
    }

// MARK: -
// MARK: register flow
    // register flow last step
    func registerUser(username: String, token: String) async throws -> ApiSuccessResponse<String?> {
        let requestInput = RegisterUserRequest(username: username, token: token)
        let task = networkManager.postRequest(
            ApiEndPoints.Customer.register,
            payload: requestInput
        ).serializingDecodable(ApiSuccessResponse<String?>.self)
        let result = try await networkManager.serializingDecodableTaskHandler(task)
        return result
    }
        
    func registerUsername(username: String) async throws -> ApiSuccessResponse<RegisterUsernameResponse?> {
        let payload = RegisterUsernameRequest(username: username)
        let task = networkManager.postRequest(ApiEndPoints.Customer.registerUsername, payload: payload)
            .serializingDecodable(ApiSuccessResponse<RegisterUsernameResponse?>.self)
        let result = try await networkManager.serializingDecodableTaskHandler(task)
        return result
    }
    
    func registerPassword(username: String, password: String, token: String) async throws -> ApiSuccessResponse<String?> {
        let payload = RegisterPasswordRequest(username: username, password: password, token: token)
        OHLogInfo(payload)
        let task = networkManager.postRequest(ApiEndPoints.Customer.registerPassword, payload: payload)
            .serializingDecodable(ApiSuccessResponse<String?>.self)
        let result = try await networkManager.serializingDecodableTaskHandler(task)
        return result
    }
    // MARK: -
    // MARK: modify Customer Account Status/account closure
   private func modifyCustomerAccountStatus(username: String, statusEnum: UserStatusEnum, userToken: String) async throws -> ApiSuccessResponse<String?> {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let url =  String(format: ApiEndPoints.Customer.updateStatus, statusEnum.rawValue)
        let task = networkManager.putRequest(
            url,
            headers: headers
        ).serializingDecodable(ApiSuccessResponse<String?>.self)
        return try await networkManager.serializingDecodableTaskHandler(task)
    }

}

extension CustomerService {
    func updateAvatar(_ avatar: String, _ userToken: String) async throws -> Bool {
        let requestInput = UpdateCustomerProfileRequest(avatar: avatar)
        let response = try await updateProfile(requestInput, userToken)

        return response.status
    }
    
    func updateMarketingNotificationSetting(_ marketingEnabled: Bool, _ userToken: String) async throws -> Bool {
        let requestInput = UpdateCustomerProfileRequest(marketingEnabled: marketingEnabled)
        let response = try await updateProfile(requestInput, userToken)

        return response.status
    }
}

// MARK: -
// MARK: register flow wrapper
extension CustomerService {
    func tryRegisterUser(username: String, token: String) async throws -> (Bool, String) {
        let response = try await registerUser(username: username, token: token)
        return (response.status, response.message)
        OHLogInfo(response)
    }
    
    @MainActor
    func tryRegisterUsername(username: String) async throws -> (String?, String) {
            let response = try await registerUsername(username: username)
        return (response.data?.token, response.message)
    }
    
    func tryRegisterPassword(username: String, password: String, token: String) async throws -> (Bool, String) {
        let response = try await registerPassword(username: username, password: password, token: token)
        return (response.status, response.message)
    }
}

extension CustomerService {
    func tryModifyCustomerAccountStatus(username: String, statusEnum: UserStatusEnum, userToken: String) async throws -> (Bool, String) {
        let response = try await modifyCustomerAccountStatus(username: username, statusEnum: statusEnum, userToken: userToken)
        return (response.status, response.message)
    }

}
