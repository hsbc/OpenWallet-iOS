//
//  AppDelegate.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 6/14/22.
//

import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    
    // MARK: A notification that posts immediately after the app finishes launching.
    func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        OHLogger.shared.setup()
        assignUNUserNotificationCenterDelegate()
        requestPushNotificationPermissions()
        navigationBarAppearance()
        if let distionary = Bundle.main.infoDictionary {
            OHLogInfo("APPVersion: \(distionary["CFBundleShortVersionString"] ?? 0)" +
                     "  Build: \(distionary["CFBundleVersion"] ?? 0)")
        }
        return true
    }
    
    // MARK: Retrieves the configuration data for UIKit to use when creating a new scene.
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // MARK: Must call where UNUserNotificationCenterDelegate is
    func assignUNUserNotificationCenterDelegate() {
        // Since methods of the UNUserNotificationCenterDelegate protocol will be used in AppDelegate,
        // it needs to assign the AppDelegate object to the delegate property of the shared UNUserNotificationCenter object.
        // Reference: https://developer.apple.com/documentation/usernotifications/unusernotificationcenterdelegate
        UNUserNotificationCenter.current().delegate = self
    }
    
    // MARK: Ask user for push notification permission and request for remote notification
    func requestPushNotificationPermissions() {
        let notificatoinAuthorizationOptions: UNAuthorizationOptions = [.alert, .badge, .sound]

        UNUserNotificationCenter.current().requestAuthorization(options: notificatoinAuthorizationOptions) { granted, _ in
            OHLogInfo("Push Notificaiton Permission granted: \(granted)")
            guard granted else { return }
            
            UNUserNotificationCenter.current().getNotificationSettings {settings in
                OHLogInfo("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }

                // Register for remote notification only if the user has granted notification permissions.
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    // MARK: Receive device token once sucessfully register on APNs
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // Format deviceToken from Data to hex string
        // TODO: consider moving this to an extension of Data. [weihao.zhang]
        let token = deviceToken.map { data in String(format: "%02.2hhx", data) }.joined()
        OHLogInfo("Device Token: \(token)")
        
        // TODO: need to provide this device token to Provider Server for push notification. [Weihao.Zhang]
    }
    
    // MARK: Handle register on APNs failure
    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
      OHLogInfo("Failed to register for remote notification: \(error)")
    }
    
    // MARK: Tells the app that a remote notification arrived that indicates there is data to be fetched
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }

        OHLogInfo("Remote notification: \(aps)")
        
        return
    }
    
    // MARK: Asks the delegate how to handle a notification that arrived while the app was running in the foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo

        OHLogInfo("Catch by userNotificationCenter-willPresent: \(userInfo)")
        
        NotificationManager.shared.hasUnreadNotification.toggle()
        
        completionHandler([.banner, .sound, .badge])
    }
    
    // MARK: Asks the delegate to process the user's response to a delivered notification
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        // TODO: Add logic to handle when the user tap on foreground notification / action
        OHLogInfo("User tap on notification: \(userInfo)")
        NotificationManager.shared.showNotifications.toggle()

        completionHandler()
    }
}
// Third party keyboard forbidden
extension AppDelegate {
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard {
            return false
        }
        return true
    }
}

extension AppDelegate {
    func navigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // configure

        let backItemAppearance = UIBarButtonItemAppearance()
        backItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.backButtonAppearance = backItemAppearance

        let image = UIImage(systemName: "chevron.backward")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        appearance.setBackIndicatorImage(image, transitionMaskImage: image)

        UINavigationBar.appearance().tintColor = .black

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
    }
}
