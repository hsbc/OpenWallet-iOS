//
//  NotificationView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/6/17.
//

import SwiftUI

struct NotificationView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: NotificationViewModel = NotificationViewModel()
    @State var isShowLoading = false

    var body: some View {
        VStack(spacing: 0) {
            TopBarView(title: "Notification", backAction: { dismiss() })
                .padding(.horizontal, UIScreen.screenWidth * 0.044)
            
            if isShowLoading {
                LoadingIndicator()
            } else {
                List {
                    ForEach(0..<viewModel.notifications.count, id: \.self) { index in
                        NotificationBoard(
                            notification: $viewModel.notifications[index],
                            selectedNotificationId: $viewModel.selectedNotificationId
                        )
                        .onChange(of: viewModel.notifications[index].status) { _ in
                            let notificationId = viewModel.notifications[index].id
                            Task {
                                await viewModel.updateNotificationStatus(notificationId)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
                .listStyle(PlainListStyle())
                .refreshable {
                    await viewModel.getNotificaitons()
                }
                .overlay {
                    if viewModel.notifications.isEmpty {
                        Text("The page is empty!")
                            .font(Font.custom("SFProText-Regular", size: FontSize.info))
                    }
                }
                .overlay(alignment: .top) {
                    ToastNotification(
                        showToast: $viewModel.showFailedToFetchNotificationsWarning,
                        message: $viewModel.failedToFetchNotificationWarningMessage
                    )
                    .padding(.horizontal, 10)
                }
                .overlay(alignment: .top) {
                    ToastNotification(
                        showToast: $viewModel.showFailedToUpdateNotificationStatusWarning,
                        message: $viewModel.failedToUpdateNotificationStatusWarningMessage
                    )
                    .padding(.horizontal, 10)
                }
            }
            
            Spacer()
        }
        .viewAppearLogger(self)
        .task {
            isShowLoading = true
            await viewModel.getNotificaitons()
            isShowLoading = false
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
