//
//  WalletService.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/21.
//

import Foundation
import Alamofire

class WalletService {
    private let networkManager: NetworkManagerProtocol
    private let luckyDrawAssetType: String = "luckydraw"
    
    init(networkManager: NetworkManagerProtocol = NetWorkManager()) {
        self.networkManager = networkManager
    }
    
    func getContractList(_ userToken: String) async throws -> [UserContract] {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let task = networkManager
            .getRequest(ApiEndPoints.Wallet.getContractList, headers: headers)
            .serializingDecodable(ApiSuccessResponse<[UserContract]>.self)

        return try await networkManager.serializingDecodableTaskHandler(task).data
    }
    
    func getERC721Tokens(_ request: ERC721TokenRequest, _ userToken: String) async throws -> [TokenUrl] {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let task = networkManager
            .postRequest(ApiEndPoints.Wallet.getContractDetail, payload: request, headers: headers)
            .serializingDecodable(ApiSuccessResponse<[TokenUrl]>.self)
        let tokenUrls = try await networkManager.serializingDecodableTaskHandler(task).data
        
        let formattedTokenUrls = tokenUrls.map { (tokenUrl) -> TokenUrl in
            var token = tokenUrl
            token.tokenURI = removeTokenURIPrefix(token.tokenURI)
            return token
        }

        return formattedTokenUrls
    }
}

extension WalletService {
    func hasUserWonLuckyDraw(_ userToken: String) async throws -> Bool {
        let contracts = try await getContractList(userToken)
        let hasWonLuckyDraw = contracts.contains { contract in
            contract.assetType == luckyDrawAssetType
        }
        
        return hasWonLuckyDraw
    }
    
    private func removeTokenURIPrefix(_ tokenURI: String) -> String {
        return tokenURI.replacingOccurrences(of: EnvironmentConfig.ipfsTokenUriPrefix, with: "")
    }
}
