//
//  NavigationStateForWelcome.swift
//  OpenWallet
//
//  Created by TQ on 2022/10/31.
//

import Foundation

class NavigationStateForWelcome: ObservableObject {
    static let shared = NavigationStateForWelcome()
    
    @Published var backToWelcome: UUID = UUID()
}
