//
//  QuizService.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/13.
//

import Alamofire
import Foundation

/**
 Auth APIs request methods
 */
class QuizService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetWorkManager()) {
        self.networkManager = networkManager
    }
    
    func getQuestion(_ quizId: String, _ userToken: String) async throws -> ApiSuccessResponse<[QuestionModel]?> {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let task = networkManager.getRequest(ApiEndPoints.Quiz.getQuestion+quizId, headers: headers)
            .serializingDecodable(ApiSuccessResponse<[QuestionModel]?>.self)
        
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    func verifyAnswer(_ questionId: String, _ answer: String, _ userToken: String) async throws -> ApiSuccessResponse<Bool> {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let verifyAnswerModel = VerifyAnswerModel(answer: answer)
        let task = networkManager.postRequest(ApiEndPoints.Quiz.verifyAnswer+questionId, payload: verifyAnswerModel, headers: headers)
            .serializingDecodable(ApiSuccessResponse<Bool>.self)

        return try await networkManager.serializingDecodableTaskHandler(task)
    }
    
    func updateQuizStatus(_ quizId: String, _ userToken: String) async throws -> ApiSuccessResponse<UpdateQuizResponse?> {
        let headers = HTTPHeaders([HttpHeaderHelper.createAuthorizationTokenHeader(userToken)])
        let task = networkManager.putRequest(ApiEndPoints.Quiz.updateQuiz+"\(quizId)/COMPLETED_SUCCESSFUL", headers: headers)
            .serializingDecodable(ApiSuccessResponse<UpdateQuizResponse?>.self)
          //  .serializingDecodable(UpdateQuizResponse.self)
        return try await networkManager.serializingDecodableTaskHandler(task)
    }
}
