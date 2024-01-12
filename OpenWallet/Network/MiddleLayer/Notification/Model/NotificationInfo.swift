//
//  Notification.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/6/17.
//

import Foundation

struct NotificationInfo: Identifiable, Decodable {
    let id: Int
    let title: String
    let message: String
    let category: String?
    let createTime: Int64
    let updateTime: Int64?
    var status: NotificationStatus
}
