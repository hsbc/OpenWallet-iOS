//
//  IpfsService.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/9/22.
//

import Foundation
import Alamofire

class IpfsService {
    private let cache = NSCache<NSString, NSString>()
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetWorkManager()) {
        self.networkManager = networkManager
    }
    
    func getGatewayDomain(_ userToken: String) async throws -> String {
        if let ipfsGatewayDomain = cache.object(forKey: ApiEndPoints.Ipfs.getGatewayDomain as NSString) {
            return ipfsGatewayDomain as String
        } else {
            let task = networkManager.getRequest(ApiEndPoints.Ipfs.getGatewayDomain)
                .serializingDecodable(ApiSuccessResponse<String>.self)
            let response = try await networkManager.serializingDecodableTaskHandler(task)
        
            let gatewayDomainUrl = response.data
            cache.setObject(gatewayDomainUrl as NSString, forKey: ApiEndPoints.Ipfs.getGatewayDomain as NSString)
            
            return gatewayDomainUrl
        }
    }

    func getIpfsContent(_ tokenURI: String) async throws -> String {
        let url = "\(EnvironmentConfig.ipfsGatewayDomainUrl)/\(tokenURI)"
        let task = networkManager.getRequest(url).serializingString()
        return try await networkManager.serializingStringTaskHandler(task)
    }
    
    func getIpfsImg(_ tokenURI: String) async throws -> Data? {
        let url = "\(EnvironmentConfig.ipfsGatewayDomainUrl)/\(tokenURI)"
        let task = networkManager.getRequest(url).serializingData()
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
}
