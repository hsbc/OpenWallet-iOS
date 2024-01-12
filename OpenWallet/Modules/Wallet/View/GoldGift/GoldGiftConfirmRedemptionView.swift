//
//  GoldGiftConfirmRedemptionView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/7.
//

import SwiftUI

struct GoldGiftConfirmRedemptionView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: GoldGiftViewModel

    @State var getDeliveryInfoImmediately: Bool = true

    @State private var showCancelRedeemPopup: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            TopBarView(title: "Redeem Gold Gift", hideBackButton: true)
                .padding(.horizontal, UIScreen.screenWidth * 0.043)
                .frame(width: UIScreen.screenWidth)
                .overlay(alignment: .trailing) {
                    Text("Cancel")
                        .font(Font.custom("SFProText-Regular", size: FontSize.body))
                        .padding(.trailing)
                        .onTapGesture {
                            showCancelRedeemPopup = true
                        }
                        .accessibilityHint("Click to go to cancel redeem and back to NFT detail page.")
                }
            
            VStack {
                if viewModel.isFetchingDeliveryInfo {
                    LoadingIndicator()
                } else if viewModel.failedToFetchDeliveryInfo {
                    failedToLoadCustomerInfoView()
                } else {
                    VStack(alignment: .leading) {
                        confirmationInfoSection()
                        
                        Spacer()
                        
                        ActionButton(text: "Submit", isLoading: $viewModel.isCreatingRedemptionRequest, isDisabled: $viewModel.failedToFetchDeliveryInfo, action: {
                            Task {
                                await viewModel.submitRedemptionRequest(viewModel.asset.nftId, User.shared.token)
                            }
                        })
                        .padding(UIScreen.screenWidth * 0.043)
                        .accessibilityHint("Ensure the information is correct and click here will submit your request")
                    }
                }
            }
            .frame(width: UIScreen.screenWidth)
            .overlay(alignment: .top) {
                ToastNotification(showToast: $viewModel.showFailedToFetchDeliveryInfoNotification, message: $viewModel.failedToFetchDeliveryInfoNotificationMessage)
                    .padding(.horizontal, UIScreen.screenWidth * 0.043)
            }
            
            navigationLinks()
        }
        .task {
            if viewModel.navigateToErrorPageFromRedeemPage {
                viewModel.navigateToErrorPageFromRedeemPage = false
            }
            guard getDeliveryInfoImmediately && User.shared.isLoggin else { return }
            guard viewModel.customerBankInfo.isEmptyBankInfo else { return }
            await viewModel.getDeliveryInfo(User.shared.token)
        }
        .overlay {
            if showCancelRedeemPopup {
                GoldGiftCancelRedemptionWarning(
                    clickYesFunction: {
                        viewModel.backToNFTDetail.toggle()
                    }, clickNoFunction: {
                        showCancelRedeemPopup = false
                    }
                )
            }
        }
        
    }
}

extension GoldGiftConfirmRedemptionView {

    func failedToLoadCustomerInfoView() -> some View {
        GeometryReader { geometry in
            List {
                SwipeDownToRefreshIndicator()
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .refreshable {
                OHLogInfo("Refresh delivery info.")
                await viewModel.getDeliveryInfo(User.shared.token)
            }
        }
    }
    
    func navigationLinks() -> some View {
        Group {
            NavigationLink(
                destination: GoldGiftSuccessRedemptionView(viewModel: viewModel).modifier(HideNavigationBar()),
                isActive: $viewModel.isActiveSuccessRedeem
            ) {
                EmptyView()
            }

            NavigationLink(
                destination: ErrorView {
                    VStack(spacing: 7) {
                        ActionButton(text: "Try again") {
                            viewModel.isActiveRedeemFailed = false
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
                isActive: $viewModel.isActiveRedeemFailed
            ) {
                EmptyView()
            }

            NavigationLink(
                destination: ErrorView {
                    VStack(spacing: 7) {
                        ActionButton(text: "Try again") {
                            getDeliveryInfoImmediately = false
                            viewModel.navigateToErrorPageFromRedeemPage = false
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
                isActive: $viewModel.navigateToErrorPageFromRedeemPage
            ) {
                EmptyView()
            }
            .accessibilityHidden(true)
        }
    }
    
    func itemDetail(labelText: String, contentText: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: UIScreen.screenHeight * 0.02) {
                Text(labelText)
                    .font(Font.custom("SFProText-Regular", size: FontSize.label))
                Text(contentText)
                    .font(Font.custom("SFProText-Medium", size: FontSize.body))
            }
            .padding(.vertical, UIScreen.screenHeight * 0.02)
            .padding(.horizontal, UIScreen.screenWidth * 0.043)

            Divider()
        }
    }
    
    func confirmationInfoSection() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Confirm redemption")
                .font(Font.custom("SFProText-Regular", size: FontSize.title4))
                .padding(.vertical, UIScreen.screenHeight * 0.03)
                .padding(.horizontal, UIScreen.screenWidth * 0.043)

            VStack(spacing: 0) {
                itemDetail(labelText: "Redeemed by", contentText: viewModel.customerBankInfo.legalName)
                itemDetail(labelText: "Phone number", contentText: "+\(viewModel.customerBankInfo.phoneCountryCode) \(viewModel.customerBankInfo.phoneNumber)")
            }
            .padding(.bottom, UIScreen.screenHeight * 0.02)
            
            Text("If you have any questions, please contact your relationship manager.")
                .font(Font.custom("SFProText-Regular", size: FontSize.info))
                .padding(.horizontal, UIScreen.screenWidth * 0.043)
        }
    }

}

struct GoldGiftConfirmRedemptionView_Previews: PreviewProvider {
    @State static var customerBankInfo = CustomerBankInfo(
        legalName: "Ahmad Muhammad",
        phoneCountryCode: "971",
        phoneNumber: "2626 0000 "
    )
    
    static var previews: some View {
        GoldGiftConfirmRedemptionView(viewModel: GoldGiftViewModel(customerBankInfo: customerBankInfo))
    }
}
