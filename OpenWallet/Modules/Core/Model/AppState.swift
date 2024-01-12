//
//  AppState.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 6/17/22.
//

import Foundation
import Combine

class AppState: ObservableObject {
    // MARK: declare a shared instance for AppState to make it available anywhere in app, like NSApp or UIApplication.shared. [weihao.zhang]
    // Reference: https://stackoverflow.com/questions/63597783/accessing-appstate-in-appdelegate-with-swiftuis-new-ios-14-life-cycle
    static let shared = AppState()
    static let defaultErrorMesssage: String = "Sorry, something is wrong. Please try again."
    static let passwordRule: String = "Password must be 8-20 characters, includes at least three of the four types: upper/lower letters, number or symbols."
    static let usernameHelpInfo: String = "The username should be 6-30 characters long and can be any combination of lower and/or upper case letters, numbers, or underscore(_)."
    
    @Published var selectedTab: Tab = Tab.home
    @Published var showCoverScreen: Bool = false
    @Published var showPopup: Bool = false
    @Published var popupSettings: PopUpSettings = PopUpSettings(title: "Timeout notification",
                                                                messages: ["Your session has expired due to timed out."],
                                                                buttonText: "Got it")
}
