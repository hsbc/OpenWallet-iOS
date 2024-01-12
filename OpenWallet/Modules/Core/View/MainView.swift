//
//  MainView.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 5/24/22.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var appState: AppState = AppState.shared
    
    @StateObject var walletVM = GoldGiftViewModel()

    private var singleTabWidth: CGFloat = UIScreen.main.bounds.width / 3
    private var tabHightlightBarHeight: CGFloat = 2
    private var tabBarHeight: CGFloat = 49 // 49pt is the standard tabbar height recommended by Apple. It seems there is no way to get tabbar height programatically with SwiftUI. [weihao.zhang]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                tabViews()
            }
            .modifier(HideNavigationBar())
        }
        .accentColor(Color("#333333"))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

extension MainView {
    func tabViews() -> some View {
        TabView(selection: $appState.selectedTab) {
            UaeHome()
                .tabItem {
                    Image(appState.selectedTab == Tab.home ? "Home full" : "Home")
                        .renderingMode(.template)
                        .foregroundColor(.black)
                        .imageScale(.large)
                    
                    Text("\(Tab.home.label)")
                        .font(Font.custom("SFProText-Medium", size: FontSize.caption))
                }
                .tag(Tab.home)
                .modifier(HideNavigationBar())
            
            GoldGiftWallet(viewModel: walletVM)
                .tabItem {
                    Image(appState.selectedTab == Tab.wallet ? "Wallet full" : "Wallet")
                        .renderingMode(.template)
                        .foregroundColor(.black)
                        .imageScale(.large)
                    Text("\(Tab.wallet.label)")
                }
                .tag(Tab.wallet)
                .modifier(HideNavigationBar())
            
            ProfileView()
                .tabItem {
                    Image(appState.selectedTab == Tab.profile ? "Profile full" : "Profile")
                        .renderingMode(.template)
                        .foregroundColor(.black)
                        .imageScale(.large)
                    Text("\(Tab.profile.label)")
                }
                .tag(Tab.profile)
                .modifier(HideNavigationBar())
        }
        .accentColor(.black)
        .ignoresSafeArea()
        .overlay(alignment: .bottomLeading) {
            Rectangle()
                .fill(.red)
                .offset(x: getHighlightBarXOffset())
                .frame(width: singleTabWidth, height: tabHightlightBarHeight)
                .padding(.bottom, tabBarHeight - tabHightlightBarHeight)
                .animation(nil, value: appState.selectedTab)
                .accessibilityHidden(true)
        }.task {
            await walletVM.getWalletAssets(User.shared.token)
        }
    }
    
    func getHighlightBarXOffset() -> CGFloat {
        switch appState.selectedTab {
        case Tab.home:
            return singleTabWidth * 0
        case Tab.wallet:
            return singleTabWidth * 1
        case Tab.profile:
            return singleTabWidth * 2
        default:
            return .infinity
        }
    }
}

struct MainViewHeaderBar: View {
    @ObservedObject var appState: AppState = AppState.shared
    @ObservedObject var user: User = User.shared
    @ObservedObject var notificationManager: NotificationManager = NotificationManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("\(appState.selectedTab.displayHeader)")
                    .font(Font.custom("SFProText-Medium", size: FontSize.body))
                    .accessibilityAddTraits(.isHeader)

                HStack {
                    Spacer()
                    if user.isLoggin {
                        NavigationLink(
                            destination: NotificationView().modifier(HideNavigationBar()),
                            isActive: $notificationManager.showNotifications
                        ) {
                            EmptyView()
                        }
                        .accessibilityHidden(true)

                        Button(action: {
                            notificationManager.showNotifications.toggle()
                        }, label: {
                            Image(systemName: "bell")
                                .font(.system(size: 25))
                                .overlay(notificationManager.hasUnreadNotification ? Badge() : nil)
                                .accessibilityLabel("Notification")
                                .accessibilityHint("Click to go to notification page.")
                        })
                        .buttonStyle(.plain)
                    } else if appState.selectedTab == Tab.home {
                        NavigationLink(
                            destination: WelcomeView().modifier(HideNavigationBar())
                        ) {
                            Image("Profile")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .accessibilityLabel("Log on")
                                .accessibilityHint("Click to go to welcome page.")
                        }
                    }
                }
            }
            .padding(.horizontal)
            
        }.frame(maxHeight: UIScreen.screenHeight*0.058)
        
    }
}
