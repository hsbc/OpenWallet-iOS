//
//  ProfileView.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 5/24/22.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var navigationState: NavigationStateForProfile = NavigationStateForProfile.shared
    @ObservedObject var navigationStateWelcome: NavigationStateForWelcome = NavigationStateForWelcome.shared
    @ObservedObject var user: User = User.shared
    @ObservedObject var notificationManager: NotificationManager = NotificationManager.shared
    @StateObject var viewModel: ProfileViewModel = ProfileViewModel()
    
    @State var showChangePasswordView: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Image("profile-bg")
                    .resizable()
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight * 0.223)
                    .background(.black) // this is a workaround since the image cannot fit perfectly to the top and side edges. [weihao.zhang]
                    .ignoresSafeArea(.all, edges: [.top, .leading, .trailing])
                
                Spacer()
            }
            .accessibilityHidden(true)
            
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    headerBar()
                    
                    Text("Me")
                        .foregroundColor(.white)
                        .font(Font.custom("SFProDisplay-Regular", size: FontSize.largeHeadline))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, UIScreen.screenHeight * 0.02)
                    
                    usernameBoard()
                        .padding(.bottom, UIScreen.screenHeight * 0.02)
                }
                .padding(.horizontal, UIScreen.screenWidth * 0.043)
                
                ScrollView {
                    VStack(spacing: 0) {
                        Group {
                            securityDigitalIdentityPanel()
                            Divider()
                            // Temporarily take out the notification setting for now. [weihao.zhang]
//                            notificationPanel()
//                            Divider()
                            passwordPanel()
                        }
                        VStackDivider(color: Color("#ededed"), width: 4)
                        Group {
                            fqaPanel()
                            Divider()
                            helpCenterPanel()
                        }
                        VStackDivider(color: Color("#ededed"), width: 4)
                        Group {
                            termsAndConditionsPanel()
                        }
                        VStackDivider(color: Color("#ededed"), width: 4)
                        Group {
                            deleteProfilePanel()
                            Divider()
                            logoutPanel()
                            Divider()
                        }
                    }
                }
                
                Spacer()
            }
        }
        .viewAppearLogger(self)
        .task {
            navigationState.backToProfile = false

            guard User.shared.isLoggin else { return }

            do {
                _ = try await NotificationManager.shared.getNotificaitons(User.shared.token)
            } catch {
                OHLogInfo(error)
            }
        }
        .overlay {
            if viewModel.isLoggingOut {
                LoadingIndicator()
            }
        }
    }

}

extension ProfileView {
    func headerBar() -> some View {
        HStack {
            Spacer()
            
            NavigationLink(
                destination: NotificationView().modifier(HideNavigationBar())
            ) {
                VStack {
                    Image("Icon-notification")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .overlay(notificationManager.hasUnreadNotification ? Badge() : nil)
                }
                .frame(width: UIScreen.screenWidth * 0.117, height: UIScreen.screenWidth * 0.117)
                .background(.white)
                .clipShape(Circle())
            }
            .accessibilityElement(children: .combine)
            .accessibilityHint("Click to go to notification page.")
        }
    }
    
    func usernameBoard() -> some View {
        NavigationLink(
            destination: ProfileAvatarView(
                selectedAvatar: user.profileImage.isEmpty ? user.defaultProfileImage : user.profileImage
            ).modifier(HideNavigationBar())
        ) {
            HStack(spacing: 0) {
                Image(user.profileImage.isEmpty ? user.defaultProfileImage : user.profileImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .background(Color("#f3f3f3"))
                    .clipShape(Circle())
                    .padding(.leading, UIScreen.screenWidth * 0.043)
                
                Text(user.name.isEmpty ? "" : user.name )
                    .font(Font.custom("SFProText-Regular", size: FontSize.body))
                    .padding(.leading, UIScreen.screenWidth * 0.027)
                
                Spacer()
            }
            .frame(width: UIScreen.screenWidth * 0.915, height: UIScreen.screenSize.height * 0.094)
            .background(Color.white.shadow(radius: 5))
        }
        .id(navigationState.backToProfile)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Click to update user avatar and/or user name.")
    }
    
    func securityDigitalIdentityPanel() -> some View {
        NavigationLink(
            destination: SecurityIdentityView().modifier(HideNavigationBar())
        ) {
            ProfileItemNavigationPanel(
                image: Image("Icon-sdi"),
                label: "Security digital identity",
                iconWidth: 20,
                iconHeight: 20
            ) {
                EmptyView()
            }
            .disabled(true)
        }
        .id(navigationState.backToProfile)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Click to view security digital identity.")
    }
    
    func notificationPanel() -> some View {
        ProfileItemNavigationPanel(
            image: Image("Icon-notification"),
            label: "Notification",
            iconWidth: 20,
            iconHeight: 20
        ) {
            NotificationSettingsView().modifier(HideNavigationBar())
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("Click to go to notification page.")
    }
    
    func passwordPanel() -> some View {
        NavigationLink(
            destination: ChangePasswordView(scenario: ChangePasswordScenario.changePassword, showChangePasswordView: $showChangePasswordView)
                .modifier(HideNavigationBar()),
            isActive: $showChangePasswordView
        ) {
            Button {
                showChangePasswordView = true
            } label: {
                ProfileItemNavigationPanel(
                    image: Image("Icon-password"),
                    label: "Password",
                    iconWidth: 20,
                    iconHeight: 20
                ) {
                    EmptyView()
                }.disabled(true)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("Click to change password.")
    }
    
    func fqaPanel() -> some View {
        NavigationLink(
            destination: FAQView(viewModel: viewModel).modifier(HideNavigationBar())
        ) {
            ProfileItemNavigationPanel(
                image: Image("Help"),
                label: "FAQ",
                iconWidth: 20,
                iconHeight: 20
            ) {
                EmptyView()
            }
            .disabled(true)
        }
        .id(navigationState.backToProfile)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Click to check frequent asked questions.")
    }
    
    func helpCenterPanel() -> some View {
        NavigationLink(
            destination: HelpCenterView().modifier(HideNavigationBar())
        ) {
            ProfileItemNavigationPanel(
                image: Image("Icon-help"),
                label: "Help center",
                iconWidth: 20,
                iconHeight: 20
            ) {
                EmptyView()
            }
            .disabled(true)
        }
        .id(navigationState.backToProfile)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Click to send message to Help center.")
    }
    
    func termsAndConditionsPanel() -> some View {
        NavigationLink(
            destination: ProfileTermsAndConditions().modifier(HideNavigationBar())
        ) {
            ProfileItemNavigationPanel(
                image: Image("Icon-T&C"),
                label: "T&C",
                iconWidth: 20,
                iconHeight: 20
            ) {
                EmptyView()
            }
            .disabled(true)
        }
        .id(navigationState.backToProfile)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Click to view terms and conditions.")
    }
    
    func logoutPanel() -> some View {
        Group {
            Button {
                viewModel.preSignOutConfirmation.toggle()
            } label: {
                HStack(alignment: .center) {
                    Image("Icon-signout")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Log out")
                        .font(Font.custom("SFProText-Regular", size: FontSize.body))
                        .foregroundColor(.black)
                        .frame(height: 24)
                    Spacer()
                }
                .modifier(ProfileItem())
                .accessibilityElement(children: .combine)
                .accessibilityHint("Click to view terms and conditions.")
            }
            .confirmationDialog(
                "Are you sure?",
                isPresented: $viewModel.preSignOutConfirmation,
                titleVisibility: .visible
            ) {
                Button(
                    "Yes. Please sign me out.",
                    role: .destructive,
                    action: {
                        Task {
                            viewModel.isLoggingOut = true
                            let logoutSuccessfully = await User.shared.logoutUser()
                            viewModel.isLoggingOut = false

                            WalletAsset.shared.removeCachedAssets()
                            WalletAsset.shared.removeCashedAssetsDetails()
                            
                            if logoutSuccessfully {
                                navigationStateWelcome.backToWelcome = UUID()
                            }
                        }
                    }
                )
            }
        }
    }
    
    func deleteProfilePanel() -> some View {
        ProfileItemNavigationPanel(
            image: Image("Icon_clear"),
            label: "Delete profile",
            iconWidth: 20,
            iconHeight: 20
        ) {
            DeleteProfileView(viewModel: viewModel)
                .modifier(HideNavigationBar())
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("Click to delete profile.")

    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

struct ProfileItemNavigationPanel<Content: View>: View {
    @State var image: Image
    @State var label: String = ""
    @State var iconWidth: CGFloat = 0
    @State var iconHeight: CGFloat = 0
    @ViewBuilder var destination: Content

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(alignment: .center) {
                image
                    .resizable()
                    .frame(width: iconWidth, height: iconHeight)
                Text(label)
                    .font(Font.custom("SFProText-Regular", size: FontSize.body))
                    .foregroundColor(.black)
                    .frame(height: 24)
                Spacer()
                Image(systemName: "chevron.forward")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 16)
                    .foregroundColor(Color("#333333"))
            }
            .modifier(ProfileItem())
        }
    }
}

struct ProfileItem: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
    }
}
