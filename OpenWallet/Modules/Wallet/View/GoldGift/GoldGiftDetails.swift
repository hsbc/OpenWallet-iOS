//
//  GoldGiftDetails.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/6.
//

import SwiftUI

struct GoldGiftDetails: View {
    @Environment(\.dismiss) var dismiss

    @State var assetDetails: NFTTokenDetails

    var body: some View {
        VStack(spacing: 0) {
            TopBarView(title: "Gold Gift details", backAction: { dismiss() })
                .padding(.top, UIScreen.screenHeight * 0.012)
                .padding(.bottom, UIScreen.screenHeight * 0.017)

            VStack(alignment: .leading, spacing: 15) {
                namePanel()
                Divider()
//                eligibilityDetails()
//                Divider()
                materialDetails()
                Divider()
//                statusDetails()
//                Divider()
                itemInformation()
            }
            .padding(.horizontal, UIScreen.screenWidth * 0.021)
            .padding(.vertical, UIScreen.screenHeight * 0.021)
            .border(Color("#ededed"), width: 1)
    
            Spacer()
        }
        .viewAppearLogger(self)
        .padding(.horizontal, UIScreen.screenWidth * 0.044)
    }
    
}

extension GoldGiftDetails {
    
    func namePanel() -> some View {
        HStack(alignment: .center, spacing: UIScreen.screenWidth * 0.045) {
            Image("Icon-gold")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.screenWidth * 0.171)
            Text(assetDetails.name)
                .font(Font.custom("SFProText-Regular", size: FontSize.body))
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
    
    func eligibilityDetails() -> some View {
        VStack(spacing: 8) {
            HStack {
                Text("Eligibility")
                    .font(Font.custom("SFProText-Regular", size: FontSize.info))
                Spacer()
                Text(assetDetails.ownedBy)
                    .font(Font.custom("SFProText-Medium", size: FontSize.info))
            }
            
            if assetDetails.serialNumber != nil {
                HStack {
                    Text("NFT serial number")
                        .font(Font.custom("SFProText-Regular", size: FontSize.info))
                    Spacer()
                    Text(assetDetails.serialNumber!.addLeadingPadding("0", 5))
                        .font(Font.custom("SFProText-Medium", size: FontSize.info))
                }
            }
        }
    }
    
    func materialDetails() -> some View {
        VStack(spacing: 8) {
            HStack {
                Text("Material")
                    .font(Font.custom("SFProText-Regular", size: FontSize.info))
                Spacer()
                Text(assetDetails.material)
                    .font(Font.custom("SFProText-Medium", size: FontSize.info))
            }
            
            HStack {
                Text("Fineness")
                    .font(Font.custom("SFProText-Regular", size: FontSize.info))
                Spacer()
                Text(assetDetails.fineness)
                    .font(Font.custom("SFProText-Medium", size: FontSize.info))
            }
            
            HStack {
                Text("Weight")
                    .font(Font.custom("SFProText-Regular", size: FontSize.info))
                Spacer()
                Text(assetDetails.weight)
                    .font(Font.custom("SFProText-Medium", size: FontSize.info))
            }
        }
    }
    
    func statusDetails() -> some View {
        VStack(spacing: 8) {
            HStack {
                Text("Status")
                    .font(Font.custom("SFProText-Regular", size: FontSize.info))
                Spacer()
                Text(assetDetails.status.getStatusDisplayValue())
                    .font(Font.custom("SFProText-Medium", size: FontSize.info))
            }
            
            if assetDetails.status == NFTStatus.redeemable || assetDetails.status == NFTStatus.redeemed {
                HStack {
                    Text(assetDetails.status == NFTStatus.redeemable ? "Expiration date" :  "Redemption date")
                        .font(Font.custom("SFProText-Regular", size: FontSize.info))
                    Spacer()
                    Text(assetDetails.datetime.mullisecondsToMonthDayYear())
                        .font(Font.custom("SFProText-Medium", size: FontSize.info))
                }
            }
        }
    }
    
    func itemInformation() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Gold item information")
                    .font(Font.custom("SFProText-Medium", size: FontSize.info))
                Spacer()
            }
            
            Text(assetDetails.goldItemInformation)
                .font(Font.custom("SFProText-Light", size: FontSize.info))
                .lineSpacing(24 - UIFont(name: "SFProText-Light", size: FontSize.info)!.lineHeight)
                .multilineTextAlignment(.leading)
        }
        
    }
    
}

struct GoldGiftDetails_Previews: PreviewProvider {
    
    @State static var assetDetails: NFTTokenDetails = NFTTokenDetails(
        name: "Limited Edition OpenWallet Gold Card",
        material: "Yellow gold",
        fineness: "18kt",
        weight: "26 grams(approx)",
        goldItemInformation: "Exclusive for you, by OpenWallet - Gold means wealth as permanence, and a gift for all time to be passed down. Gold is the gift that is not forgotten, but rather becomes the heritage that lasts forever. Gold is the gift with a meaning all its own.",
        imageList: [
            "api/blockchain/nft/token/image/SG/OpenWallet/17/0",
            "api/blockchain/nft/token/image/SG/OpenWallet/17/1"
        ],
        ownedBy: "weihao",
        status: NFTStatus.redeemed,
        datetime: 1664288363721,
        serialNumber: 1
    )
    
    static var previews: some View {
        GoldGiftDetails(assetDetails: assetDetails)
    }
}
