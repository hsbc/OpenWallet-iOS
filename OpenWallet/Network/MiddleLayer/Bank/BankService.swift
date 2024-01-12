//
//  BankService.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/28/22.
//

import Alamofire
import Foundation

/**
 Bank APIs request methods
 */
class BankService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetWorkManager()) {
        self.networkManager = networkManager
    }
    
    func getBankInfo(_ userToken: String) async throws -> CustomerBankInfo {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let task = networkManager.getRequest(
            ApiEndPoints.Bank.getInfo,
            headers: headers
        ).serializingDecodable(ApiSuccessResponse<CustomerBankInfo>.self)
        
        let response = try await networkManager.serializingDecodableTaskHandler(task)
        let customerBankInfo = response.data

        return customerBankInfo
    }
}
