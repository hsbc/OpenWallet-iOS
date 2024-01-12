//
//  UpdateNotificationStatusRequest.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/20/22.
//

import Foundation

struct UpdateNotificationStatusRequest: Encodable {
    let notificationId: Int
    let notificationStatusEnum: NotificationStatus
}
