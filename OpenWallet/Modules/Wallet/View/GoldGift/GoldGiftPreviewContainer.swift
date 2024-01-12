//
//  GoldGiftPreviewContainer.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/6.
//

import SwiftUI

struct GoldGiftPreviewContainer: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var viewModel: GoldGiftViewModel

    @State var getAssetDetailsImmediately: Bool = true
    
    @State private var collectDisabled: Bool = false
    
    var body: some View {
        VStack {
            TopBarView(title: "Gold X NFT Preview", backAction: { dismiss() })
                .padding(.horizontal, UIScreen.screenWidth * 0.029)
                .padding(.top, UIScreen.screenHeight * 0.0136)
            
            VStack(spacing: 0) {
                if viewModel.isLoadingAssetDetails {
                    LoadingIndicator()
                } else if viewModel.failedToLoadAssetDetails {
                    failedToLoadAssetDetailsView()
                } else {
                    GoldGiftPreview(assetDetails: viewModel.assetDetails)

                    if viewModel.assetDetails.status == NFTStatus.redeemable || viewModel.assetDetails.status == NFTStatus.expired {
                        ActionButton(text: "Redeem your gift", isDisabled: $collectDisabled, action: {
                            viewModel.navigateToConfirmRedemption = true
                        })
                        .padding(16)
                        .accessibilityHint("Click to go to Redeem page.")
                    }
                }
            }
            .overlay(alignment: .top) {
                ToastNotification(showToast: $viewModel.showFailedToLoadAssetDetailsAlert, message: $viewModel.failedToLoadAssetDetailsMessage)
                    .padding(.horizontal, UIScreen.screenWidth * 0.029)
            }
            
            navigationLinks()
        }
        .task {
            guard getAssetDetailsImmediately else { return }
            await viewModel.getAssetDetails(viewModel.asset, User.shared.token)
            collectDisabled = viewModel.assetDetails.status != .redeemable
        }
    }

}

extension GoldGiftPreviewContainer {
    
    func failedToLoadAssetDetailsView() -> some View {
        GeometryReader { geometry in
            List {
                VStack {
                    Text("Failed to load asset details")
                        .font(Font.custom("SFProText-Regular", size: FontSize.body))
                    Text("(Swipe down to retry)")
                        .font(Font.custom("SFProText-Regular", size: FontSize.info))
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .refreshable {
                OHLogInfo("Refresh assets details.")
                viewModel.removeCachedAssetsDetails()
                await viewModel.getAssetDetails(viewModel.asset, User.shared.token)
                collectDisabled = viewModel.assetDetails.status != .redeemable
            }
        }
    }
    
    func navigationLinks() -> some View {
        Group {
            NavigationLink(
                destination: GoldGiftConfirmRedemptionView(viewModel: viewModel).modifier(HideNavigationBar()),
                isActive: $viewModel.navigateToConfirmRedemption
            ) {
                EmptyView()
            }
            .id(viewModel.backToNFTDetail)
            
            NavigationLink(
                destination: ErrorView {
                    VStack(spacing: 7) {
                        ActionButton(text: "Try again") {
                            getAssetDetailsImmediately = false
                            viewModel.navigateToErrorPageFromGiftPreviewPage = false
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
                isActive: $viewModel.navigateToErrorPageFromGiftPreviewPage
            ) {
                EmptyView()
            }
            .accessibilityHidden(true)
        }
    }
    
}

struct GoldGiftPreviewContainer_Previews: PreviewProvider {
    @State static var assetDetails: NFTTokenDetails = NFTTokenDetails(
        name: "Limited Edition OpenWallet Gold Card",
        material: "Yellow gold",
        fineness: "18kt",
        weight: "26 grams(approx)",
        goldItemInformation: "Exclusive for you, by OpenWallet - Gold means wealth as\npermanence, and a gift for all time to be passed down.\nGold is the gift that is not forgotten, but rather becomes\nthe heritage that lasts forever. Gold is the gift with a\nmeaning all its own.",
        imageList: [
            "api/blockchain/nft/token/image/SG/OpenWallet/17/0",
            "api/blockchain/nft/token/image/SG/OpenWallet/17/1"
        ],
        ownedBy: "weihao",
        status: NFTStatus.redeemable,
        datetime: 1664288363721,
        serialNumber: nil
    )
    
    @State static var viewModel = GoldGiftViewModel(assetDetails: assetDetails)
    
    static var previews: some View {
        GoldGiftPreviewContainer(viewModel: viewModel)
    }
}
