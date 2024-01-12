//
//  FeedbackService.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 10/27/22.
//

import Alamofire
import Foundation

/**
 Feedback APIs request methods
 */
class FeedbackService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetWorkManager()) {
        self.networkManager = networkManager
    }

    func sendFeedback(_ feedbackContent: String, _ userToken: String) async throws -> ApiSuccessResponse<String?> {
        let requestInput = AddFeedbackRequest(content: feedbackContent)
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])

        let task = networkManager.postRequest(
            ApiEndPoints.Feedback.sendFeedback,
            payload: requestInput,
            headers: headers
        ).serializingDecodable(ApiSuccessResponse<String?>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
}
