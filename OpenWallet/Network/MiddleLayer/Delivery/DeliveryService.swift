//
//  DeliveryService.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/29/22.
//

import Alamofire
import Foundation

/**
 Delivery APIs request methods
 */
class DeliveryService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetWorkManager()) {
        self.networkManager = networkManager
    }

    func createDelivery(_ nftId: Int, _ userToken: String) async throws -> Bool {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let requestInput = RedemptionRequest(nftId: nftId)
        let task = networkManager.postRequest(
            ApiEndPoints.Delivery.createDelivery,
            payload: requestInput,
            headers: headers
        ).serializingDecodable(ApiSuccessResponse<RequestRedemptionResponse?>.self)
        
        let response = try await networkManager.serializingDecodableTaskHandler(task)

        return response.status
    }
}
