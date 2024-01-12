//
//  GoldGiftAssetCard.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/25/22.
//

import SwiftUI

struct GoldGiftAssetCard: View {
    @Binding var asset: NFTBasicInfo
    @Binding var failedToLoadAssets: Bool
    
    @State var infoSectionHeight: CGFloat = 120
    
    var body: some View {
        
        GeometryReader { geometry in
            if asset.isValidAsset {
                VStack(spacing: 0) {
                    assetImage()
                        .frame(width: geometry.size.width, height: geometry.size.height - infoSectionHeight) // Image take 70% of the card. [weihao.zhang]
                    
                    assetInfo()
                        .padding(.horizontal, geometry.size.width * 0.048)
                        .frame(width: geometry.size.width, height: infoSectionHeight) // Info take the other 30% of the card. [weihao.zhang]
                }
            } else {
                VStack {
                    Text(failedToLoadAssets ? "Failed to fetch asset" : "No asset info available")
                        .font(Font.custom("SFProText-Regular", size: FontSize.body))
                    Text("(Swipe down to retry)")
                        .font(Font.custom("SFProText-Regular", size: FontSize.info))
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            }
        }
        
    }
}

extension GoldGiftAssetCard {
    
    func assetImage() -> some View {
        NFTMultipleMediaView(url: asset.singlePreviewImageUrl(),
                            userToken: User.shared.token,
                            ext: judgeExtension(url: asset.singlePreviewImageUrl()))
        .accessibilityLabel("NFT is assigned to you")
        .accessibilityHint("Click to go to Wallet page.")
    }
    
    func assetInfo() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Text(asset.name)
                    .font(Font.custom("SFProText-Medium", size: FontSize.body))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color("#333333"))
                Spacer()
                HStack {
                    Text(asset.status.getStatusDisplayValue())
                        .font(Font.custom("SFProText-Regular", size: FontSize.info))
                        .foregroundColor(Color("#333333"))
                    Circle()
                        .fill(asset.status.getStatusColor())
                        .frame(width: 8, height: 8)
                }
            }

            Text("Eligibility: \(asset.ownedBy)")
                .font(Font.custom("SFProText-Regular", size: FontSize.info))
                .foregroundColor(Color("#333333"))
            
            if asset.status == NFTStatus.redeemed {
                Text("Redeemed on: \(asset.datetime.mullisecondsToMonthDayYear())")
                    .font(Font.custom("SFProText-Regular", size: FontSize.info))
                    .foregroundColor(Color("#333333"))
            }
        }
    }
    
}

struct GoldGiftAssetCard_Previews: PreviewProvider {
    @State static var asset = NFTBasicInfo(
        imageURI: ["/nft/token/image/SG/OpenWallet/2/0"],
        tokenURI: "api/blockchain/nft/token/detail/SG/OpenWallet/",
        datetime: 1664288363721,
        name: "Limited Edition OpenWallet Gold Key",
        nftId: -1,
        edition: "2022 Limited Edition",
        ownedBy: "weihao",
        status: .redeemed
    )
    
    static var previews: some View {
        GoldGiftAssetCard(asset: $asset, failedToLoadAssets: .constant(false), infoSectionHeight: 120)
            .frame(width: UIScreen.screenWidth * 0.915, height: UIScreen.screenHeight * 0.419, alignment: .center)
            .background(Color.white.shadow(radius: 1))
    }
}
