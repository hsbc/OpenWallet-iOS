//
//  TnCService.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 10/9/22.
//

import Alamofire
import Foundation

/**
 TnC APIs request methods
 */
class TnCService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetWorkManager()) {
        self.networkManager = networkManager
    }
    
    /**
     Get terms and conditions by category and language. Use this method with user token after log on.
     */
    func getTncByCategoryAndLanguage(category: TnCCategory, language: TnCLanguage, userToken: String) async throws -> ApiSuccessResponse<TnC?> {
        let url = getGetTncByCategoryAndLanguageEndPoint(category: category, language: language)
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let requestInput = GetTnCRequest(token: userToken)

        let task = networkManager.postRequest(url, payload: requestInput, headers: headers).serializingDecodable(ApiSuccessResponse<TnC?>.self)
        let response = try await networkManager.serializingDecodableTaskHandler(task)
        
        return response
    }
    
    /**
     Get terms and conditions by category and language. Use this method with secret token provided during the pre-log-on workflow, e.g., registration
     */
    func getTncByCategoryAndLanguage(category: TnCCategory, language: TnCLanguage, secretToken: String) async throws -> ApiSuccessResponse<TnC?> {
        let url = getGetTncByCategoryAndLanguageEndPoint(category: category, language: language)
        let requestInput = GetTnCRequest(token: secretToken)

        let task = networkManager.postRequest(
            url,
            payload: requestInput
        ).serializingDecodable(ApiSuccessResponse<TnC?>.self)
        let response = try await networkManager.serializingDecodableTaskHandler(task)
        OHLogInfo(response)
        return response
    }
}

extension TnCService {
    private func getGetTncByCategoryAndLanguageEndPoint(category: TnCCategory, language: TnCLanguage) -> String {
        return ApiEndPoints.TnC.getTncByCategoryAndLanguage
            .replacingOccurrences(of: "{category}", with: category.rawValue)
            .replacingOccurrences(of: "{language}", with: language.rawValue)
    }
}
