//
//  NFTService.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/25/22.
//

import Alamofire
import Foundation

/**
 NFT APIs request methods
 */
class NFTService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetWorkManager()) {
        self.networkManager = networkManager
    }
    
    func getNFTs(_ userToken: String) async throws -> [NFTBasicInfo] {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let task = networkManager.getRequest(
            ApiEndPoints.NFT.getNFTList,
            headers: headers
        ).serializingDecodable(ApiSuccessResponse<[NFTBasicInfo]>.self)
        
        let response = try await networkManager.serializingDecodableTaskHandler(task)
        let nfts = response.data
        
        return nfts
    }
    
    func getNFTTokenDetails(_ tokenURI: String, _ userToken: String) async throws -> NFTTokenDetails {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let url = getNFTTokenDetailUrl(tokenURI)
        let task = networkManager.getRequest(
            url,
            headers: headers
        ).serializingDecodable(ApiSuccessResponse<NFTTokenDetails>.self)

        let response = try await networkManager.serializingDecodableTaskHandler(task)
        let details = response.data

        return details
    }
    
    func getNFTTokenImage(_ imageURI: String, _ userToken: String) async throws -> Data {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let imageUrl = getNFTTokenImageUrl(imageURI)
        let task = networkManager.getRequest(
            imageUrl,
            headers: headers
        ).serializingData()

        let data = try await networkManager.serializingDecodableTaskHandler(task)

        return data
    }
    
    func hasExpiringToken(_ userToken: String) async throws -> Bool {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let task = networkManager.getRequest(
            ApiEndPoints.NFT.hasExpiringToken,
            headers: headers
        ).serializingDecodable(ApiSuccessResponse<Bool>.self)

        let reponse = try await networkManager.serializingDecodableTaskHandler(task)

        return reponse.data
    }
}

extension NFTService {
    func getNFTTokenImageUrl(_ imageURI: String) -> String {
        return "\(EnvironmentConfig.middleLayerBaseUrl)/\(imageURI)"
    }
    
    func getNFTTokenDetailUrl(_ tokenURI: String) -> String {
        return "\(EnvironmentConfig.middleLayerBaseUrl)/\(tokenURI)"
    }
}
