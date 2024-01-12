//
//  NavigationStateForRegister.swift
//  OpenWallet
//
//  Created by TQ on 2022/10/31.
//

import Foundation

class NavigationStateForRegister: ObservableObject {
    static let shared = NavigationStateForRegister()
    
    @Published var registerToRoot: Bool = false
}
