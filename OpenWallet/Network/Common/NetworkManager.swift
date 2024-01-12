//
//  NetworkManager.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/6/21.
//

import Foundation
import Alamofire

class NetWorkManager: NetworkManagerProtocol {
    private var session: Session
    
    init(
        session: Session = Session(
            configuration: URLSessionConfiguration.OpenWalletOpenConfiguration,
            interceptor: MiddleLayerRequestInterceptor(),
            serverTrustManager: EnvironmentConfig.enableSSLPinning ? ServerTrustManager(evaluators: ServerTrustEvaluators.defaultEvaluators) : nil
        )
    ) {
        self.session = session
    }

    func getRequest(
        _ url: URLConvertible,
        headers: HTTPHeaders? = nil
    ) -> DataRequest {
        let updatedHeaders = mergeHeaders(NetworkHeaders.commonHeaders, headersToMerge: headers)

        return session.request(url, headers: updatedHeaders)
            .validate(statusCode: 200 ..< 300)
    }
    
    func getRequest<T: Encodable>(
        _ url: URLConvertible,
        payload: T,
        headers: HTTPHeaders? = nil,
        encoder: ParameterEncoder = URLEncodedFormParameterEncoder(destination: .queryString)
    ) -> DataRequest {
        let updatedHeaders = mergeHeaders(NetworkHeaders.commonHeaders, headersToMerge: headers)

        return session.request(
            url,
            method: .get,
            parameters: payload,
            encoder: encoder,
            headers: updatedHeaders
        )
        .validate(statusCode: 200 ..< 300)
    }
    
    func postRequest<T: Encodable>(
        _ url: URLConvertible,
        payload: T,
        headers: HTTPHeaders? = nil,
        encoder: ParameterEncoder = JSONParameterEncoder.default
    ) -> DataRequest {
        let updatedHeaders = mergeHeaders(NetworkHeaders.commonHeaders, headersToMerge: headers)

        return session.request(
            url,
            method: .post,
            parameters: payload,
            encoder: encoder,
            headers: updatedHeaders
        )
        .validate(statusCode: 200 ..< 300)
    }
    
    func postRequest(
        _ url: URLConvertible,
        headers: HTTPHeaders? = nil
    ) -> DataRequest {
        let updatedHeaders = mergeHeaders(NetworkHeaders.commonHeaders, headersToMerge: headers)

        return session.request(url, method: .post, headers: updatedHeaders).validate(statusCode: 200 ..< 300)
    }

    func putRequest<T: Encodable>(
        _ url: URLConvertible,
        payload: T? = nil,
        headers: HTTPHeaders? = nil,
        encoder: ParameterEncoder = JSONParameterEncoder.default
    ) -> DataRequest {
        let updatedHeaders = mergeHeaders(NetworkHeaders.commonHeaders, headersToMerge: headers)

        guard payload != nil  else {
            return session.request(url, method: .put, headers: updatedHeaders).validate(statusCode: 200 ..< 300)
            
        }
        
        return session.request(
            url,
            method: .put,
            parameters: payload,
            encoder: encoder,
            headers: updatedHeaders
        )
        .validate(statusCode: 200 ..< 300)
    }

    func putRequest(
        _ url: URLConvertible,
        headers: HTTPHeaders? = nil
    ) -> DataRequest {
        let updatedHeaders = mergeHeaders(NetworkHeaders.commonHeaders, headersToMerge: headers)

        return session.request(
            url,
            method: .put,
            headers: updatedHeaders
        )
        .validate(statusCode: 200 ..< 300)
    }
}

extension NetWorkManager {
    /**
     @ Summary
     Handler for 'responseDecodable' method of a DataRquest
     
     @ Example:
    func infoCheckUsernameTask(_ username: String, completion: @escaping (Result<InfoCheckResponse, ApiErrorResponse>) -> Void) {
         let infoToCheck = InfoCheckUsername(username: username)

         NetWorkManager.shared.postRequest(ApiEndPoints.Auth.infoCheckUsername, payload: infoToCheck)
             .responseDecodable(of: InfoCheckResponse.self) { response in
                 NetWorkManager.shared.responseDecodableHandler(response: response, completionHandler: completion)
             }
     }
     */
    func responseDecodableHandler<R: Decodable, E: Decodable & Error>(response: AFDataResponse<R>, completionHandler: @escaping (Result<R, E>) -> Void) {
        switch response.result {
        case .success(let data):
            completionHandler(.success(data))
        case .failure(let error):
            guard
                let data = response.data,
                let apiError = try? JSONDecoder().decode(E.self, from: data)
            else {
                OHLogInfo("Encounter unexpected error:")
                OHLogInfo(error)
                return
            }
            
            completionHandler(.failure(apiError))
        }
    }
    
    /**
     @ Summary
     Handler for 'serializingDecodable' method of a DataRquest. Use in a async-await way
     
     @ Example:
     func infoCheckUsername(username: String) async throws -> InfoCheckResponse {
         let infoToCheck = InfoCheckUsername(username: username)
         let task = NetWorkManager.shared.postRequest(ApiEndPoints.Auth.infoCheckEmail, payload: infoToCheck)
             .serializingDecodable(InfoCheckResponse.self)
         
         return try await NetWorkManager.shared.serializingDecodableTaskHandler(task)
     }
     */
    func serializingDecodableTaskHandler<T: Decodable>(_ task: DataTask<T>) async throws -> T {
        let result = await task.result
        switch result {
        case .success:
            break
        case .failure:
            let response = await task.response
            OHLogInfo(response)
            OHLogInfo(result)
            guard response.data != nil else {
                let apiError = ApiErrorResponse(message: "Unknown Error", status: false, data: nil)
                OHLogInfo(apiError)
                throw apiError
            }
            
            // TODO: find a way to replace 'ApiErrorResponse' with a Generics. [weihao.zhang]
            let apiError = try JSONDecoder().decode(ApiErrorResponse.self, from: response.data!)
            OHLogInfo(apiError)
            throw apiError as ApiErrorResponse
        }
        
        let value = try await task.value
        return value
    }
    
    func serializingStringTaskHandler(_ task: DataTask<String>) async throws -> String {
        let result = await task.result
        switch result {
        case .success:
            break
        case .failure:
            let response = await task.response
            OHLogInfo(response)
            OHLogInfo(result)
            guard response.data != nil else {
                let apiError = ApiErrorResponse(message: "Unknown Error", status: false, data: nil)
                OHLogInfo(apiError)
                throw apiError
            }

            // TODO: find a way to replace 'ApiErrorResponse' with a Generics. [weihao.zhang]
            let apiError = try JSONDecoder().decode(ApiErrorResponse.self, from: response.data!)
            OHLogInfo(apiError)
            throw apiError
        }
        
        let value = try await task.value
        return value
    }
    
    private func mergeHeaders(_ headers: HTTPHeaders, headersToMerge: HTTPHeaders?) -> HTTPHeaders {
        guard headersToMerge != nil else { return NetworkHeaders.commonHeaders }
        
        var mergedHeaders = NetworkHeaders.commonHeaders.sorted()
        
        for (key, value) in headersToMerge!.dictionary {
            mergedHeaders.update(name: key, value: value)
        }
        
        return mergedHeaders
    }
}
