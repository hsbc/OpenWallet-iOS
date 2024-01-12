//
//  URLSessionConfiguration.swift
//  OpenWalletStaff
//
//  Created by WEIHAO ZHANG on 9/8/22.
//

import Alamofire
import Foundation

extension URLSessionConfiguration {
    static var OpenWalletOpenConfiguration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.af.default
        
        if EnvironmentConfig.includeServerGatewayAccessCookie
            && !EnvironmentConfig.serverGatewayAccessCookieName.isEmpty
            && !EnvironmentConfig.serverGatewayAccessCookieValue.isEmpty {
            // Create a custom cookie for the backend service gateway load balancer. [weihao.zhang]
            let cookieProperties = [
                HTTPCookiePropertyKey.domain: EnvironmentConfig.serverHost,
                HTTPCookiePropertyKey.path: "/",
                HTTPCookiePropertyKey.name: EnvironmentConfig.serverGatewayAccessCookieName,
                HTTPCookiePropertyKey.value: EnvironmentConfig.serverGatewayAccessCookieValue
            ] as [HTTPCookiePropertyKey: Any]
            
            if let cookie = HTTPCookie(properties: cookieProperties) {
                configuration.httpCookieStorage?.setCookie(cookie)
            }
        }

        return configuration
    }
}
