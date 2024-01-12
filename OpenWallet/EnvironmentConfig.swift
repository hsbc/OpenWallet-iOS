//
//  Cofiguration.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/20/22.
//

import Foundation

public enum EnvironmentConfig {
    enum Keys {
        static let appName = "OW_APP_NAME"
        static let appDisplayName = "OW_APP_DISPLAY_NAME"
        static let appBundleId = "OW_APP_BUNDLE_ID"
        static let hideCoverScreen = "OW_HIDE_COVER_SCREEN"
        static let middleLayerBaseUrl = "OW_MIDDLE_LAYER_BASE_URL"
        static let serverHost = "OW_SERVER_HOST"
        static let includeServerGatewayAccessCookie = "INCLUDE_SERVER_GATEWAY_ACCESS_COOKIE"
        static let serverGatewayAccessCookieName = "OW_SERVER_GATEWAY_ACCESS_COOKIE_NAME"
        static let serverGatewayAccessCookieValue = "OW_SERVER_GATEWAY_ACCESS_COOKIE_VALUE"
        static let serverCertificateFileName = "OW_SERVER_CERTIFICATE_FILE_NAME"
        static let serverCertificateFileExtension = "OW_SERVER_CERTIFICATE_FILE_EXTENSION"
        static let includeSourceHeaderInHttpCalls = "INCLUDE_SOURCE_HEADER_IN_HTTP_CALLS"
        static let sourceDeviceHttpHeaderName = "SOURCE_DEVICE_HTTP_HEADER_NAME"
        static let ipfsGatewayDomainUrl = "OW_IPFS_GATEWAY_DOMAIN_URL"
        static let ipfsTokenUriPrefix = "IPFS_TOKEN_URI_PREFIX"
        static let enableSSLPinning = "OW_ENABLE_SSL_PINNING"
    }
    
    // Read Info.plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Info.plist not found.")
        }
        return dict
    }()

    // Read app display name
    static let appDisplayName: String = {
        guard let appDisplayName = EnvironmentConfig.infoDictionary[Keys.appDisplayName] as? String else {
            fatalError("\(Keys.appDisplayName) not found in Info.plist.")
        }
        return appDisplayName
    }()
    
    // Read app appBundleId
    static let appBundleId: String = {
        guard let appBundleId = EnvironmentConfig.infoDictionary[Keys.appBundleId] as? String else {
            fatalError("\(Keys.appBundleId) not found in Info.plist.")
        }
        return appBundleId
    }()

    // Read hide cover screen config
    static let hideCoverScreen: Bool = {
        guard let hideCoverScreenConfig = EnvironmentConfig.infoDictionary[Keys.hideCoverScreen] as? String else {
            fatalError("\(Keys.hideCoverScreen) not found in Info.plist.")
        }

        let hideCoverScreen = hideCoverScreenConfig.lowercased() == "yes" || hideCoverScreenConfig.lowercased() == "true"
        return hideCoverScreen
    }()
    
    // Read hide cover screen config
    static let enableSSLPinning: Bool = {
        guard let enableSSLPinningConfig = EnvironmentConfig.infoDictionary[Keys.enableSSLPinning] as? String else {
            fatalError("\(Keys.enableSSLPinning) not found in Info.plist.")
        }

        let enableSSLPinning = enableSSLPinningConfig.lowercased() == "yes" || enableSSLPinningConfig.lowercased() == "true"
        return enableSSLPinning
    }()
    
    // Read Middle Layer base url setting
    static let middleLayerBaseUrl: String = {
        guard let baseUrl = EnvironmentConfig.infoDictionary[Keys.middleLayerBaseUrl] as? String else {
            fatalError("\(Keys.middleLayerBaseUrl) not found in Info.plist.")
        }
        return baseUrl
    }()
    
    // Read include server gateway access cookie config
    static let includeServerGatewayAccessCookie: Bool = {
        guard let includeServerGatewayAccessCookieConfig = EnvironmentConfig.infoDictionary[Keys.includeServerGatewayAccessCookie] as? String else {
            fatalError("\(Keys.includeServerGatewayAccessCookie) not found in Info.plist.")
        }

        let includeServerGatewayAccessCookie = includeServerGatewayAccessCookieConfig.lowercased() == "yes" || includeServerGatewayAccessCookieConfig.lowercased() == "true"
        return includeServerGatewayAccessCookie
    }()
    
    // Read server gateway access cookie name
    static let serverGatewayAccessCookieName: String = {
        guard let cookieName = EnvironmentConfig.infoDictionary[Keys.serverGatewayAccessCookieName] as? String else {
            fatalError("\(Keys.serverGatewayAccessCookieName) not found in Info.plist.")
        }
        return cookieName
    }()
    
    // Read server gateway access cookie value
    static let serverGatewayAccessCookieValue: String = {
        guard let cookieValue = EnvironmentConfig.infoDictionary[Keys.serverGatewayAccessCookieValue] as? String else {
            fatalError("\(Keys.serverGatewayAccessCookieValue) not found in Info.plist.")
        }
        return cookieValue
    }()
    
    // Read server domain
    static let serverHost: String = {
        guard let host = EnvironmentConfig.infoDictionary[Keys.serverHost] as? String else {
            fatalError("\(Keys.serverHost) not found in Info.plist.")
        }
        return host
    }()
    
    // Read server certificate file name
    static let serverCertificateFileName: String = {
        guard let fileName = EnvironmentConfig.infoDictionary[Keys.serverCertificateFileName] as? String else {
            fatalError("\(Keys.serverCertificateFileName) not found in Info.plist.")
        }
        return fileName
    }()
    
    // Read server certificate file extension
    static let serverCertificateFileExtension: String = {
        guard let fileExtension = EnvironmentConfig.infoDictionary[Keys.serverCertificateFileExtension] as? String else {
            fatalError("\(Keys.serverCertificateFileExtension) not found in Info.plist.")
        }
        return fileExtension
    }()

    // Read include source header in http calls config
    static let includeSourceHeaderInHttpCalls: Bool = {
        guard let includeSourceHeaderInHttpCallsConfig = EnvironmentConfig.infoDictionary[Keys.includeSourceHeaderInHttpCalls] as? String else {
            fatalError("\(Keys.includeSourceHeaderInHttpCalls) not found in Info.plist.")
        }

        let includeSourceHeaderInHttpCalls = includeSourceHeaderInHttpCallsConfig.lowercased() == "yes" || includeSourceHeaderInHttpCallsConfig.lowercased() == "true"
        return includeSourceHeaderInHttpCalls
    }()
    
    // Read server certificate file extension
    static let sourceDeviceHttpHeaderName: String = {
        guard let httpHeaderName = EnvironmentConfig.infoDictionary[Keys.sourceDeviceHttpHeaderName] as? String else {
            fatalError("\(Keys.sourceDeviceHttpHeaderName) not found in Info.plist.")
        }
        return httpHeaderName
    }()

    // Read ipfs gateway domain url setting
    static let ipfsGatewayDomainUrl: String = {
        guard let gatewayDomainUrl = EnvironmentConfig.infoDictionary[Keys.ipfsGatewayDomainUrl] as? String else {
            fatalError("\(Keys.ipfsGatewayDomainUrl) not found in Info.plist.")
        }
        return gatewayDomainUrl
    }()
    
    static let ipfsTokenUriPrefix: String = {
        guard let prefix = EnvironmentConfig.infoDictionary[Keys.ipfsTokenUriPrefix] as? String else {
            fatalError("\(Keys.ipfsTokenUriPrefix) not found in Info.plist.")
        }
        return prefix
    }()
}
