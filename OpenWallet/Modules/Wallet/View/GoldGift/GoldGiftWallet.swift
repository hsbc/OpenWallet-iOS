//
//  GoldGiftWallet.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/6.
//
import SwiftUI

struct GoldGiftWallet: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: GoldGiftViewModel
    @ObservedObject var notificationManager: NotificationManager = NotificationManager.shared
    
    @State var getWalletAssetsImmediately: Bool = true

    @State private var assetCardInfoSectionHeight: CGFloat = 120
    private let giftImageRatio: CGFloat = 686.0 / 512.0
    
    var body: some View {
        ZStack {
            backgroundSection()

            VStack(spacing: 0) {
                headerBar()
                
                Text("OpenWallet Open Wallet")
                    .foregroundColor(.white)
                    .font(Font.custom("SFProDisplay-Regular", size: FontSize.largeHeadline))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, UIScreen.screenHeight * 0.039)
                    .overlay(alignment: .top) {
                        ToastNotification(showToast: $viewModel.showFailedToLoadAssetsAlert, message: $viewModel.failedToLoadAssetsMessage)
                    }
                
                assetBoard()
                
                navigationLinks()

                Spacer()
            }
            .padding(.horizontal, UIScreen.screenWidth * 0.043)
        }
        .viewAppearLogger(self)
        .task {
            guard getWalletAssetsImmediately && User.shared.isLoggin else { return }

            do {
                _ = try await NotificationManager.shared.getNotificaitons(User.shared.token)
            } catch {
                OHLogInfo(error)
            }
        }
    }
}

extension GoldGiftWallet {
    func backgroundSection() -> some View {
        VStack {
            Image("headers-bg")
                .resizable()
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight * 0.313, alignment: .top)
                .border(Color("#252525"), width: 1)
            
            Spacer()
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }

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
    
    func assetBoard() -> some View {
        List {
            EmptyView()
        }
        .listStyle(PlainListStyle())
        .frame(width: UIScreen.screenWidth * 0.915, height: (UIScreen.screenWidth * 0.915 / giftImageRatio) + assetCardInfoSectionHeight, alignment: .center)
        .background(Color.white.shadow(radius: 1))
        .refreshable {
            OHLogInfo("Refresh assets.")
            viewModel.removeCachedAssets()
            viewModel.removeCachedAssetsDetails()
            await viewModel.getWalletAssets(User.shared.token)
        }
        .overlay {
            NavigationLink {
                GoldGiftPreviewContainer(viewModel: viewModel).modifier(HideNavigationBar())
            } label: {
                if viewModel.isLoadingAssets {
                    ProgressView()
                } else {
                    GoldGiftAssetCard(asset: $viewModel.asset, failedToLoadAssets: $viewModel.failedToLoaddAssets, infoSectionHeight: assetCardInfoSectionHeight)
                        .overlay {
                            assetRefresher()
                        }
                }
            }
            .accessibilityHint("Click to go to NFT detail page.")
            .disabled(viewModel.isLoadingAssets || !viewModel.asset.isValidAsset)
            .foregroundColor(.black)
        }
    }
    
    func assetRefresher() -> some View {
        // A dummpy List to support pull down to refresh
        List {
            EmptyView()
        }
        .listStyle(PlainListStyle())
        .refreshable {
            OHLogInfo("Refresh assets.")
            viewModel.removeCachedAssets()
            viewModel.removeCachedAssetsDetails()
            await viewModel.getWalletAssets(User.shared.token)
        }
        .opacity(0.1)
    }
    
    func navigationLinks() -> some View {
        Group {
            NavigationLink(
                destination: ErrorView {
                    VStack(spacing: 7) {
                        ActionButton(text: "Try again") {
                            getWalletAssetsImmediately = false
                            viewModel.navigateToErrorPage = false
                        }
                        
                        NavigationLink(
                            destination: MainView().modifier(HideNavigationBar()),
                            isActive: $viewModel.navigateToHomePage
                        ) {
                            EmptyView()
                        }
                        .accessibilityHidden(true)
                        
                        ActionButton(text: "Go back to home", isPrimaryButton: false) {
                            AppState.shared.selectedTab = .home
                            viewModel.navigateToHomePage = true
                        }
                    }
                }.modifier(HideNavigationBar()),
                isActive: $viewModel.navigateToErrorPage
            ) {
                EmptyView()
            }
            .accessibilityHidden(true)
        }
    }

}

struct GoldGiftWallet_Previews: PreviewProvider {
    @StateObject static var viewModel = GoldGiftViewModel()
    static var previews: some View {
        GoldGiftWallet(viewModel: viewModel)
    }
}
