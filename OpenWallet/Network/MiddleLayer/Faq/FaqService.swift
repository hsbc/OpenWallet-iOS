//
//  FaqService.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/22.
//

import Alamofire
import Foundation

class FaqService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetWorkManager()) {
        self.networkManager = networkManager
    }

    func getFaq(_ userToken: String) async throws -> [QAModel]? {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let task = networkManager.getRequest(
            ApiEndPoints.FAQ.getFAQ,
            headers: headers
        ).serializingDecodable(ApiSuccessResponse<[QAModel]?>.self)

        let response = try await networkManager.serializingDecodableTaskHandler(task)
        
        return response.data
    }
}
