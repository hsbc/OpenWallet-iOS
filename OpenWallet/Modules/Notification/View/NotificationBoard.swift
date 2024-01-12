//
//  NotificationBoard.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/20/22.
//

import SwiftUI

struct NotificationBoard: View {
    @Binding var notification: NotificationInfo
    @Binding var selectedNotificationId: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 16) {
                Text(getDisplayPostedTime(notification.updateTime ?? notification.createTime))
                    .font(Font.custom("SFProText-Regular", size: FontSize.caption))
                    .foregroundColor(Color("#333333"))
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(notification.title)
                            .font(Font.custom("SFProText-Regular", size: FontSize.body))
                            .foregroundColor(Color("#333333"))
                        Spacer()
                        if notification.status == NotificationStatus.unread {
                            unreadMarker
                        }
                    }

                    Text(notification.message)
                        .font(Font.custom("SFProText-Light", size: FontSize.body))
                        .foregroundColor(Color("#333333"))
                        .lineLimit(showAllMessage ? nil : 1)
                }
            }
            .padding([.leading, .trailing], 16)
            
            Divider()
        }
        .listRowInsets(.init(top: 8, leading: 0, bottom: 0, trailing: 0))
        .listRowSeparator(.hidden)
        .onTapGesture {
            if notification.status != NotificationStatus.read {
                notification.status = NotificationStatus.read
            }
            
            // This is to support fold/unfold behavior. [weihao.zhang]
            if selectedNotificationId != notification.id {
                selectedNotificationId = notification.id
            } else {
                selectedNotificationId = nil
            }
        }
    }
}

extension NotificationBoard {
    var showAllMessage: Bool {
        selectedNotificationId == notification.id
    }
    
    var unreadMarker: some View {
        Text("")
            .frame(width: 8, height: 8)
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(Circle())
    }
    
    func getDisplayPostedTime(_ postedTime: Int64) -> String {
        // posted time is stored in milliseconds while TimeInterval is specified in seconds
        let timeIntervalInSeconds = TimeInterval(postedTime / 1000)
        let date = Date(timeIntervalSince1970: timeIntervalInSeconds)
        return date.toNotificationPostedDateFormat
    }
}

struct NotificationBoard_Previews: PreviewProvider {
    static var notification1: NotificationInfo = NotificationInfo(
        id: 1,
        title: "Thank you for Registering",
        message: "Welcome to Open Harbor!",
        category: "ACCOUNT_ACTIVITY",
        createTime: 1656637057,
        updateTime: nil,
        status: NotificationStatus.unread
    )
    
    static var notification2: NotificationInfo = NotificationInfo(
        id: 2,
        title: "Lucky Draw",
        message: "Join Infinity 1865 lucky draw to win Lion NFT! Join Infinity 1865 lucky draw to win Lion NFT! Join Infinity 1865 lucky draw to win Lion NFT! Join Infinity 1865 lucky draw to win Lion NFT!",
        category: "ACCOUNT_ACTIVITY",
        createTime: 1659142657,
        updateTime: nil,
        status: NotificationStatus.unread
    )
    
    @State static var notifications = [notification1, notification2]
    @State static var selectedId: Int? = 1
    
    static var previews: some View {
        List {
            ForEach(0..<notifications.count, id: \.self) { index in
                NotificationBoard(notification: $notifications[index], selectedNotificationId: $selectedId)
                    .swipeActions(edge: .trailing) {
                        Button {
                          OHLogInfo("Bookmark")
                        } label: {
                          Label("Bookmark", systemImage: "bookmark")
                        }.tint(.indigo)
                    }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .listStyle(GroupedListStyle())
    }
}
