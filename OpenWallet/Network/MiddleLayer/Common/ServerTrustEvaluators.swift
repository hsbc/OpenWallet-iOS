//
//  ServerTrustEvaluators.swift
//  OpenWalletStaff
//
//  Created by WEIHAO ZHANG on 8/29/22.
//

import Alamofire

class ServerTrustEvaluators {
    
    static let defaultEvaluators: [String: ServerTrustEvaluating] = [
        "\(EnvironmentConfig.serverHost)": PublicKeysTrustEvaluator()
    ]
    
}
