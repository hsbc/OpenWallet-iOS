//
//  MiddleLayerRequestInterceptor.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/21/22.
//

import Foundation
import Alamofire

class MiddleLayerRequestInterceptor: RequestInterceptor {
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest
        
        DispatchQueue.main.async {
            User.shared.checkIfShouldRenewAccessToken()
        }
        
        if EnvironmentConfig.includeSourceHeaderInHttpCalls {
            // Add a http header with 'Source' as key, device uuid as value to all middle layer request. [weihao.zhang]
            let httpHeaderForSourceDevice = HttpHeaderHelper.createSourceHeader()
            request.setValue(httpHeaderForSourceDevice.value, forHTTPHeaderField: httpHeaderForSourceDevice.name)
        }
        
        completion(.success(request))
    }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        let response = request.task?.response as? HTTPURLResponse
        
        if let statusCode = response?.statusCode, let httpHeaders = request.request?.allHTTPHeaderFields {
            let isAuthorizationHeaderSpecifiied = httpHeaders.keys.contains("Authorization")
            // We might only want to handle authentication error different when the request has Authorization http header specified and returns 401. [weihao.zhang]
            if statusCode == 401 && isAuthorizationHeaderSpecifiied {
                handleAuthenticationError()
            }
            completion(.doNotRetryWithError(error))
        } else {
            return completion(.doNotRetry)
        }
    }
    
    private func handleAuthenticationError() {
        Task {
            await MainActor.run {
                AppState.shared.showPopup = true
            }
            await User.shared.logoutUser()
        }
    }
}
