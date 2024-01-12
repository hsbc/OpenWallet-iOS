//
//  NetworkHeaders.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/14/22.
//

import Alamofire

struct NetworkHeaders {
    static let commonHeaders: HTTPHeaders = HTTPHeaders(
        [
            "Content-Type": "application/json",
            "OpenWallet-Client-Id": "ClientId",
            "OpenWallet-Source-System-Id": "SourceSystemID",
            "OpenWallet-GBGF": "GBGF",
            "OpenWallet-Global-Channel-Id": "MOBILE",
            "OpenWallet-Chnl-CountryCode": "ChannelCountryCode",
            "OpenWallet-Chnl-Group-Member": "ChannelGroupMember",
            "Accept-Language": "AcceptLanguage"
        ]
    )
}
