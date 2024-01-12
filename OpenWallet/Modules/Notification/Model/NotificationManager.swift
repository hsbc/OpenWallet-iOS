//
//  NotificationManager.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/21/22.
//

import Foundation

@MainActor
class NotificationManager: ObservableObject {
    static let shared: NotificationManager = NotificationManager()
    
    @Published var showNotifications: Bool = false
    @Published var hasUnreadNotification: Bool = false
    
    var notifications: [NotificationInfo] = []
    
    let notificationService: NotificationService
    
    init(notificationService: NotificationService = NotificationService()) {
        self.notificationService = notificationService
    }
    
    @discardableResult
    func getNotificaitons(_ userToken: String) async throws -> [NotificationInfo] {
        // Clean up current notifications before fetching from backend again. [weihao.zhang]
        notifications.removeAll()

        notifications = try await notificationService.getNotifications(userToken)

        hasUnreadNotification = !notifications.isEmpty && notifications.contains(where: { notification in
            notification.status == NotificationStatus.unread
        })
        
        return notifications
    }
    
    func updateNotificationStatus(_ notificationId: Int, _ userToken: String) async throws  -> Bool {
        let response = try await notificationService.updateStatus(notificationId, userToken)
        return response.status
    }
    
    func clearAllNotifications() {
        notifications.removeAll()
    }
}
