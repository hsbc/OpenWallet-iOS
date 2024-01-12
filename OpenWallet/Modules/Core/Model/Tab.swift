//
//  Tab.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 5/27/22.
//

// Make sure Tab is conform to Int because the tab raw value will be used to calculate highlight bar position. [Weihao.Zhang]
enum Tab: Int {
    case home = 0
    case wallet = 1
    case marketplace = 2
    case learn = 3
    case profile = 4
    
    var label: String {
        switch self {
        case .home:
            return "Home"
        case .wallet:
            return "Wallet"
        case .marketplace:
            return "Marketplace"
        case .learn:
            return "Learn"
        case .profile:
            return "Profile"
        }
    }
    
    var displayHeader: String {
        switch self {
        case .home:
            return EnvironmentConfig.appDisplayName
        case .wallet:
            return "Wallet"
        case .marketplace:
            return "Marketplace"
        case .learn:
            return "Learn list"
        case .profile:
            return "My Profile"
        }
    }
}
