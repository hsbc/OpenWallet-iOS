//
//  NetworkManagerProtocol.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/14/22.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func getRequest(_ url: URLConvertible, headers: HTTPHeaders?) -> DataRequest
    
    func getRequest<T: Encodable>(_ url: URLConvertible, payload: T, headers: HTTPHeaders?, encoder: ParameterEncoder) -> DataRequest
    
    func postRequest(_ url: URLConvertible, headers: HTTPHeaders?) -> DataRequest
    
    func postRequest<T: Encodable>(_ url: URLConvertible, payload: T, headers: HTTPHeaders?, encoder: ParameterEncoder) -> DataRequest
    
    func putRequest(_ url: URLConvertible, headers: HTTPHeaders?) -> DataRequest
    
    func putRequest<T: Encodable>(_ url: URLConvertible, payload: T?, headers: HTTPHeaders?, encoder: ParameterEncoder) -> DataRequest
    
    func serializingDecodableTaskHandler<T: Decodable>(_ task: DataTask<T>) async throws -> T
    
    func serializingStringTaskHandler(_ task: DataTask<String>) async throws -> String
}

/**
Use protocol extension to let method support default arguments
 */
extension NetworkManagerProtocol {
    func getRequest(
        _ url: URLConvertible,
        headers: HTTPHeaders? = nil
    ) -> DataRequest {
        getRequest(url, headers: headers)
    }

    func getRequest<T: Encodable>(
        _ url: URLConvertible,
        payload: T,
        headers: HTTPHeaders? = nil,
        encoder: ParameterEncoder = URLEncodedFormParameterEncoder(destination: .queryString)
    ) -> DataRequest {
        getRequest(url, payload: payload, headers: headers, encoder: encoder)
    }
    
    func postRequest(
        _ url: URLConvertible,
        headers: HTTPHeaders? = nil
    ) -> DataRequest {
        postRequest(url, headers: headers)
    }
    
    func postRequest<T: Encodable>(
        _ url: URLConvertible,
        payload: T,
        headers: HTTPHeaders? = nil,
        encoder: ParameterEncoder = JSONParameterEncoder.default
    ) -> DataRequest {
        postRequest(url, payload: payload, headers: headers, encoder: encoder)
    }
    
    func putRequest(
        _ url: URLConvertible,
        headers: HTTPHeaders? = nil
    ) -> DataRequest {
        putRequest(url, headers: headers)
    }
    
    func putRequest<T: Encodable>(
        _ url: URLConvertible,
        payload: T? = nil,
        headers: HTTPHeaders? = nil,
        encoder: ParameterEncoder = JSONParameterEncoder.default
    ) -> DataRequest {
        putRequest(url, payload: payload, headers: headers, encoder: encoder)
    }
}
