//
//  NotificationSettingsView.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/31/22.
//

import SwiftUI

struct NotificationSettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var receiveMarketingNotfications: Bool = true  // this should be a global setting retrive from the server. [weihao.zhang]
    @State private var isUpdatingMarketingNotificationSetting: Bool = false

    @State private var showAlert: Bool = false
    @State private var updateNotificationSettingErrorMessage: String = "Changing notification setting failed, please try again."

    private let customerService: CustomerService = CustomerService()

    var body: some View {
        VStack(spacing: UIScreen.screenHeight * 0.016) {
            TopBarView(title: "Notification Settings", backAction: {dismiss()})
                .padding(.horizontal, UIScreen.screenWidth * 0.044)
            
            VStack(alignment: .leading, spacing: UIScreen.screenHeight * 0.025) {
                marketingNotificationsSetting()

                Divider()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Receive the latest marketing offers and promotions.")
                        .font(Font.custom("SFProText-Regular", size: FontSize.caption))
                    
                    Text("Please ensure Push Notifications are enabled in both the app and phone settings to ensure notifications can be received.")
                        .font(Font.custom("SFProText-Regular", size: FontSize.caption))
                }
                .padding(.leading, UIScreen.screenWidth * 0.043)
                .padding(.trailing, UIScreen.screenWidth * 0.059)
            }
            .overlay(alignment: .top) {
                ToastNotification(showToast: $showAlert, message: $updateNotificationSettingErrorMessage)
                    .padding(.horizontal, 10)
            }
            .viewAppearLogger(self)
            Spacer()
        }
    }
}

extension NotificationSettingsView {
    func marketingNotificationsSetting() -> some View {
        HStack {
            Text("Marketing notfications")
                .font(Font.custom("SFProText-Regular", size: FontSize.body))

            Spacer()
            
            if isUpdatingMarketingNotificationSetting {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .scaleEffect(1.2)
            } else {
                Toggle("", isOn: $receiveMarketingNotfications)
                    .toggleStyle(SwitchToggleStyle(tint: Color("#000000")))
                    .onChange(of: receiveMarketingNotfications) { marketingNotificationEnabled in
                        updateMarketingNotificationSetting(marketingNotificationEnabled)
                    }
                    .frame(width: UIScreen.screenWidth * 0.136)
            }
        }
        .frame(height: UIScreen.screenHeight * 0.038)
        .padding(.horizontal, UIScreen.screenWidth * 0.043)
    }
    
    func updateMarketingNotificationSetting(_ settingEnabled: Bool) {
        Task { @MainActor in
            do {
                isUpdatingMarketingNotificationSetting = true

                let updateSettingSuccess = try await customerService.updateMarketingNotificationSetting(settingEnabled, User.shared.token)

                if !updateSettingSuccess {
                    // hanlde update setting failed scenario
                    receiveMarketingNotfications = false
                    showAlert = true
                }

                isUpdatingMarketingNotificationSetting = false
            } catch {
                // hanlde update setting failed scenario
                isUpdatingMarketingNotificationSetting = false
            }

        }
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    @State static var receiveMarketingNotfications: Bool = false
    
    static var previews: some View {
        NotificationSettingsView(receiveMarketingNotfications: receiveMarketingNotfications)
    }
}
