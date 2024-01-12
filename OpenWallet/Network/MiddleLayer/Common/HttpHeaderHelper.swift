//
//  HttpHeaderHelper.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/8/22.
//

import Alamofire
import Foundation
import SwiftUI

class HttpHeaderHelper {
    /**
     @ Summary
     Create an Authorization HTTPHeader for MiddlerLayer
     */
    static func createAuthorizationTokenHeader(_ token: String) -> HTTPHeader {
        return HTTPHeader(name: "Authorization", value: "OH \(token)")
    }
    
    /**
     @ Summary
     Create an Source HTTPHeader for MiddlerLayer
     */
    static func createSourceHeader() -> HTTPHeader {
        let deviceIdentifier: String = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        return HTTPHeader(name: EnvironmentConfig.sourceDeviceHttpHeaderName, value: deviceIdentifier)
    }
}
