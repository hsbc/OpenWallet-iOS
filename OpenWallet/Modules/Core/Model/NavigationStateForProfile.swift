//
//  NavigationStateForProfile.swift
//  OpenWallet
//
//  Created by TQ on 2022/10/31.
//

import Foundation

class NavigationStateForProfile: ObservableObject {
    static let shared = NavigationStateForProfile()
    
    @Published var backToProfile: Bool = false
}
