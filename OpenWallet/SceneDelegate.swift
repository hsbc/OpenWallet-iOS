//
//  SceneDelegate.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 6/20/22.
//

import UIKit
import Combine

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        OHLogInfo("WillEnterForeground")
        AppState.shared.showCoverScreen = false
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        OHLogInfo("DidEnterBackground")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0

        OHLogInfo("DidBecomeActive")
        AppState.shared.showCoverScreen = false
    }

    func sceneWillResignActive(_ scene: UIScene) {
        OHLogInfo("WillResignActive")
        AppState.shared.showCoverScreen = true && !EnvironmentConfig.hideCoverScreen
    }
    
}
