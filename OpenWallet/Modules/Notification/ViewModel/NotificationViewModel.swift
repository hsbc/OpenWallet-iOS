//
//  Notification-ModelView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/6/17.
//

import Foundation

@MainActor
class NotificationViewModel: ObservableObject {
    @Published var notifications: [NotificationInfo] = []
    @Published var selectedNotificationId: Int?
    
    @Published var isFetchingNotifications: Bool = false
    @Published var showFailedToFetchNotificationsWarning: Bool = false
    @Published var failedToFetchNotificationWarningMessage: String = AppState.defaultErrorMesssage
    
    @Published var showFailedToUpdateNotificationStatusWarning: Bool = false
    @Published var failedToUpdateNotificationStatusWarningMessage: String = AppState.defaultErrorMesssage
    
    func getNotificaitons() async {
        guard User.shared.isLoggin else { return }
        
        do {
            notifications = try await NotificationManager.shared.getNotificaitons(User.shared.token)
        } catch let apiErrorResponse as ApiErrorResponse {
            OHLogInfo(apiErrorResponse)
            showFailedToFetchNotificationsWarning = true
            failedToFetchNotificationWarningMessage = "\(apiErrorResponse.message ?? AppState.defaultErrorMesssage)"
        } catch {
            OHLogInfo(error)
            showFailedToFetchNotificationsWarning = true
            failedToFetchNotificationWarningMessage = AppState.defaultErrorMesssage
        }
    }
    
    func updateNotificationStatus(_ notificationId: Int) async {
        do {
            _ = try await NotificationManager.shared.updateNotificationStatus(notificationId, User.shared.token)
        } catch let apiErrorResponse as ApiErrorResponse {
            OHLogInfo(apiErrorResponse)
            showFailedToUpdateNotificationStatusWarning = true
            failedToUpdateNotificationStatusWarningMessage = "\(apiErrorResponse.message ?? AppState.defaultErrorMesssage)"
        } catch {
            OHLogInfo(error)
            showFailedToUpdateNotificationStatusWarning = true
            failedToUpdateNotificationStatusWarningMessage = AppState.defaultErrorMesssage
        }
    }
}
