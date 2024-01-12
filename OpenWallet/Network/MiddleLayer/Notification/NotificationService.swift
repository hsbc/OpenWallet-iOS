//
//  NotificationService.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/20/22.
//

import Alamofire
import Foundation

/**
 Notification APIs request methods
 */
class NotificationService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetWorkManager()) {
        self.networkManager = networkManager
    }
    
    /**
     @ Summary
     Get all notifications for the user
     
     @ Return
     A list of NotificationInfo
     */
    func getNotifications(_ userToken: String) async throws -> [NotificationInfo] {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let task = networkManager.getRequest(
            ApiEndPoints.Notification.getNotifications,
            headers: headers
        ).serializingDecodable(ApiSuccessResponse<[NotificationInfo]>.self)

        let response = try await networkManager.serializingDecodableTaskHandler(task)
        
        return response.data.sorted { notificationA, notificationB in
            let timeA = notificationA.updateTime ?? notificationA.createTime
            let timeB = notificationB.updateTime ?? notificationB.createTime
            // Sort notifications from latest to oldest
            return timeA > timeB
        }
    }

    /**
     @ Summary
     Update the Read or Unread status of a notification
     
     @ Return
     */
    func updateStatus(_ notificationId: Int, _ userToken: String) async throws -> ApiSuccessResponse<String?> {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let requestUrl = "\(ApiEndPoints.Notification.updateStatus)/\(notificationId)"
        let task = networkManager.putRequest(
            requestUrl,
            headers: headers
        ).serializingDecodable(ApiSuccessResponse<String?>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
}
