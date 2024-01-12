//
//  NFTStatus.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/25/22.
//

import Foundation
import SwiftUI

enum NFTStatus: Int, Codable {
    case redeemable = 0
    case inflight = 1
    case redeemed = 2
    case expired = 3
}

extension NFTStatus {
    
    func getStatusDisplayValue() -> String {
        switch self {
        case .redeemable:
            return "Redeemable"
        case .inflight:
            return "Inflight"
        case .redeemed:
            return "Redeemed"
        case .expired:
            return "Expired"
        }
    }

    func getStatusDeliveryValue() -> String {
        switch self {
        case .redeemable, .expired:
            return "No record."
        case .inflight, .redeemed:
            return "Submittion confirmed."
        }
    }

    func getStatusColor() -> Color {
        switch self {
        case .redeemable:
            return Color("#00847f")
        case .inflight:
            return Color("#ffbb33")
        case .redeemed:
            return Color("#d7d8d6")
        case .expired:
            return Color("#a8000b")
        }
    }
    
}
