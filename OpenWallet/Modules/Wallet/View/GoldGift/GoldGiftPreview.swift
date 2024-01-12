//
//  GoldGiftPreview.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/28/22.
//

import SwiftUI

struct GoldGiftPreview: View {
    
    @State var assetDetails: NFTTokenDetails
    let horPadding: CGFloat = UIScreen.screenWidth * 0.043
    let indicatorHeight: CGFloat = 44.0
    // 设计图 ratio: 686x512，修改需要改，最好后台返回
    let carouselRatio: CGFloat = 686.0 / 512.0
    
    let redeemableExpiredRecordMessage: String = "This section will be updated after you successfully request to redeem your Gold…"
    let inflightRedeemedRecordMessage: String = "Your request to redeem your Gold Gift and initiate the creation of an NFT for OpenWallet is confirmed…"
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(assetDetails.name)
                        .font(Font.custom("SFProText-Regular", size: FontSize.title4))
                    
                    productImagesCarousel()
                    productDetail()
                    productBackground()
                    giftingRecord()
                }
                .padding(.horizontal, horPadding)
            }
            .viewAppearLogger(self)
        }
    }
}

extension GoldGiftPreview {
    func productImagesCarousel() -> some View {
        CarouselNew(
            assetDetails.imageList
                .filter({ url in
                    // feature: ignore webp which is using by Android, and ignore placeholder to have another logic
                    if url.contains(".webp") || url.contains("placeholder") {
                        return false
                    }
                    return true
                })
                .map { url in
                    let view = NFTMultipleMediaView(url: url,
                                                    userToken: User.shared.token,
                                                    ext: judgeExtension(url: url))
                    return CarouselTemplate(view: AnyView(view))
            },
            horPadding: 0,
            horInset: horPadding / 2,
            containerWidth: UIScreen.screenWidth - horPadding * 2,
            containerHeight: (UIScreen.screenWidth - horPadding * 2) / carouselRatio + indicatorHeight,
            itemWidth: UIScreen.screenWidth - horPadding * 2,
            itemBackground: Color.clear,
            indicatorHeight: indicatorHeight
        )
        .accessibilityLabel("NFT carousel pictures")
    }
    
    func productDetail() -> some View {
        VStack(alignment: .leading, spacing: 11) {
            Text("Gold Gift details")
                .font(Font.custom("SFProText-Regular", size: FontSize.title4))

            VStack(alignment: .leading, spacing: 15) {
                HStack(alignment: .center, spacing: UIScreen.screenWidth * 0.045) {
                    Image("Icon-gold")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.screenWidth * 0.171)
                    Text(assetDetails.name)
                        .font(Font.custom("SFProText-Regular", size: FontSize.body))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                
                Divider()
                
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
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Gold gift information")
                            .font(Font.custom("SFProText-Regular", size: FontSize.info))
                        Spacer()
                    }
                    
                    Text(assetDetails.goldItemInformation)
                        .font(Font.custom("SFProText-Light", size: FontSize.info))
                        .lineLimit(1)
                }
                
                HStack {
                    Spacer()
                    NavigationLink(destination: GoldGiftDetails(assetDetails: assetDetails).modifier(HideNavigationBar())) {
                        Text("View more")
                            .font(Font.custom("SFProText-Medium", size: FontSize.info))
                            .foregroundColor(Color("#e02020"))
                    }
                    .accessibilityHint("Click to go to product detail page.")
                }
                .padding(.top, 10)
            }
            .padding()
            .border(Color("#ededed"), width: 1)

        }
    }
    
    func productBackground() -> some View {
        VStack(alignment: .leading, spacing: 11) {
            Text("NFT background")
                .font(Font.custom("SFProText-Regular", size: FontSize.title4))

            VStack(spacing: 17) {
                VStack(spacing: 8) {
                    HStack {
                        Text("OpenWallet NFT ID")
                            .font(Font.custom("SFProText-Regular", size: FontSize.info))
                        Spacer()
                        Text(assetDetails.serialNumber != nil ? assetDetails.serialNumber!.addLeadingPadding("0", 10) : "N/A")
                            .font(Font.custom("SFProText-Medium", size: FontSize.info))
                    }
                    
                    HStack {
                        Text("NFT status")
                            .font(Font.custom("SFProText-Regular", size: FontSize.info))
                        Spacer()
                        Text(assetDetails.status.getStatusDisplayValue())
                            .font(Font.custom("SFProText-Medium", size: FontSize.info))
                    }
                }
                
                Divider()
                
                Image("NFT-img2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.screenWidth * 0.608)

                VStack(alignment: .leading, spacing: UIScreen.screenHeight * 0.003) {
                    HStack {
                        Text("NFTs – or Non-Fungible Tokens – are unique digital assets stored on a blockchain...")
                            .font(Font.custom("SFProText-Regular", size: FontSize.info))
                        Spacer()
                    }
                }
                
                HStack {
                    Spacer()
                    NavigationLink(destination: GoldGiftProductBackground(assetDetails: assetDetails).modifier(HideNavigationBar())) {
                        Text("View more")
                            .font(Font.custom("SFProText-Medium", size: FontSize.info))
                            .foregroundColor(Color("#e02020"))
                    }
                    .accessibilityHint("Click to go to product background page.")
                }
            }
            .padding()
            .border(Color("#ededed"), width: 1)
        }
    }

    func giftingRecord() -> some View {
        VStack(alignment: .leading, spacing: 11) {
            Text("Gifting record")
                .font(Font.custom("SFProText-Regular", size: FontSize.title4))

            VStack(spacing: 17) {
                VStack(spacing: 8) {
                    HStack {
                        Text("Eligibility")
                            .font(Font.custom("SFProText-Regular", size: FontSize.info))
                        Spacer()
                        Text(assetDetails.ownedBy)
                            .font(Font.custom("SFProText-Medium", size: FontSize.info))
                    }
                    
                    HStack {
                        Text(assetDetails.status == .redeemed ? "Redemption date" : "Expiration date")
                            .font(Font.custom("SFProText-Regular", size: FontSize.info))
                        Spacer()
                        Text(assetDetails.datetime.mullisecondsToMonthDayYear())
                            .font(Font.custom("SFProText-Medium", size: FontSize.info))
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(assetDetails.status == .inflight || assetDetails.status == .redeemed ? inflightRedeemedRecordMessage : redeemableExpiredRecordMessage)
                            .font(Font.custom("SFProText-Regular", size: FontSize.info))
                        Spacer()
                    }
                }
                
                HStack {
                    Spacer()
                    NavigationLink(destination: GoldGiftGiftingRecord(assetDetails: assetDetails).modifier(HideNavigationBar())) {
                        Text("View more")
                            .font(Font.custom("SFProText-Medium", size: FontSize.info))
                            .foregroundColor(Color("#e02020"))
                    }
                    .accessibilityHint("Click to go to product background page.")
                }
            }
            .padding()
            .border(Color("#ededed"), width: 1)
        }
    }

}

struct GoldGiftPreview_Previews: PreviewProvider {
    
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
        status: NFTStatus.redeemed,
        datetime: 1664288363721,
        serialNumber: 1
    )
    
    static var previews: some View {
        GoldGiftPreview(assetDetails: assetDetails)
    }

}
