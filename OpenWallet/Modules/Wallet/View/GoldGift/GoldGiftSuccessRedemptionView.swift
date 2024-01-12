//
//  GoldGiftSuccessRedemptionView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/8.
//

import SwiftUI

struct GoldGiftSuccessRedemptionView: View {
    @ObservedObject var viewModel: GoldGiftViewModel
    
    var body: some View {
        VStack {
            Image("NFT-success")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.screenWidth)

            NavigationLink(
                destination: MainView().modifier(HideNavigationBar()),
                isActive: $viewModel.backToWalletMain
            ) {
                EmptyView()
            }
            
            VStack(alignment: .leading, spacing: UIScreen.screenHeight * 0.015) {
                Text("Success!")
                    .font(Font.custom("SFProText-Regular", size: FontSize.largeHeadline))
                Text("Thank you for joining OpenWallet on this NFT journey!")
                    .font(Font.custom("SFProText-Medium", size: FontSize.body))
                Text("You have requested redemption of your Gold Gift and have also initiated the creation of an NFT for OpenWallet. Delivery of the Gold Gift may take some time, so thank you for your patience.")
                    .font(Font.custom("SFProText-Light", size: FontSize.body))
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(viewModel.customerBankInfo.legalName)
                        .font(Font.custom("SFProText-Medium", size: FontSize.body))
                    Text("+\(viewModel.customerBankInfo.phoneCountryCode) \(viewModel.customerBankInfo.phoneNumber)")
                        .font(Font.custom("SFProText-Medium", size: FontSize.body))
                }
                .font(Font.custom("SFProText-Medium", size: FontSize.info))
                .padding(.top, UIScreen.screenHeight * 0.027)
                
                Text("If you have any questions relating to your redemption, please contact your relationship manager.")
                    .font(Font.custom("SFProText-Light", size: FontSize.body))
                    .padding(.top, UIScreen.screenHeight * 0.027)
                
                Spacer()
                
                ActionButton(text: "Back to Wallet", action: {
                    // Remove cached assets and asset details to fetch them again. [weihao.zhang]
                    viewModel.removeCachedAssets()
                    viewModel.removeCachedAssetsDetails()
                    viewModel.backToWalletMain = true
                })
                .accessibilityHint("Click to go back to wallet page.")
            }
            .padding(UIScreen.screenWidth * 0.043)
        }
        .viewAppearLogger(self)
        .edgesIgnoringSafeArea(Edge.Set.top)
    }
    
}

struct GoldGiftSuccessRedemptionView_Previews: PreviewProvider {
    @State static var customerBankInfo = CustomerBankInfo(
        legalName: "Ahmad Muhammad",
        phoneCountryCode: "971",
        phoneNumber: "2626 0000 "
    )
    
    static var previews: some View {
        GoldGiftSuccessRedemptionView(viewModel: GoldGiftViewModel(customerBankInfo: customerBankInfo))
    }
}
