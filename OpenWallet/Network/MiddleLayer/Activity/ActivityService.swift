//
//  ActivityService.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/13.
//

import Alamofire
import Foundation

/**
 Auth APIs request methods
 */
class ActivityService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetWorkManager()) {
        self.networkManager = networkManager
    }
    
    func getQuiz(_ activityId: String) async throws -> ApiSuccessResponse<[QuizModel]> {
        let task = networkManager.getRequest(ApiEndPoints.Activity.getquiz+activityId)
            .serializingDecodable(ApiSuccessResponse<[QuizModel]>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    func getQuizByToken(_ activityId: String, _ userToken: String) async throws -> ApiSuccessResponse<[QuizModel]> {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let task = networkManager.getRequest(ApiEndPoints.Activity.getquizByToken+activityId, headers: headers)
            .serializingDecodable(ApiSuccessResponse<[QuizModel]>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    func getActivityByToken(_ userToken: String) async throws -> ApiSuccessResponse<[ActivityModel]> {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let task = networkManager.getRequest(ApiEndPoints.Activity.getActivity, headers: headers)
            .serializingDecodable(ApiSuccessResponse<[ActivityModel]>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    func getLuckyDrawActivity() async throws -> ApiSuccessResponse<[ActivityModel]> {
        let task = networkManager.getRequest(ApiEndPoints.Activity.getLuckyDraw)
            .serializingDecodable(ApiSuccessResponse<[ActivityModel]>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    @discardableResult
    func isActivityFinished(_ activityId: String, _ userToken: String) async throws -> ApiSuccessResponse<String?> {
        let url = ApiEndPoints.Activity.isActivityFinished + activityId
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let task = networkManager.getRequest(url, headers: headers)
            .serializingDecodable(ApiSuccessResponse<String?>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
}
