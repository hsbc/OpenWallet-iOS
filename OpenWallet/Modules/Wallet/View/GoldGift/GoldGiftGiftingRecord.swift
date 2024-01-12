//
//  GoldGiftGiftingRecord.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/6.
//

import SwiftUI

struct GoldGiftGiftingRecord: View {
    @Environment(\.dismiss) var dismiss
    
    @State var assetDetails: NFTTokenDetails
    @State private var navigate: Bool = false

    var body: some View {
        VStack {
            TopBarView(title: "Gifting record", backAction: { dismiss() })
                .padding(.horizontal, UIScreen.screenWidth * 0.029)
                .padding(.top, UIScreen.screenHeight * 0.0136)
            
            VStack(alignment: .leading, spacing: UIScreen.screenHeight * 0.029) {
                VStack(alignment: .leading) {
                    Text("Eligibility: \(assetDetails.ownedBy)")
                    Text("\(assetDetails.status == .redeemed ? "Redemption date" : "Expiration date"): \(assetDetails.datetime.mullisecondsToMonthDayYear())")
                }
                .font(Font.custom("SFProDisplay-Regular", size: FontSize.body))

                if assetDetails.status == .inflight || assetDetails.status == .redeemed {
                    helpMessagesForSubmittionConfirmed()
                } else {
                    helpMessagesForNoRecord()
                }
            }
            .padding(.top, UIScreen.screenHeight*0.028)
            .padding(.horizontal, UIScreen.screenWidth*0.029)
            Spacer()
        }
    }

}

extension GoldGiftGiftingRecord {

    func helpMessagesForNoRecord() -> some View {
        Group {
            Text("The section will be updated after you successfully request to redeem your Gold Gift. By doing so, you will also initiate the creation of the NFT for OpenWallet!\n\nIf you have any queries or feedback about our NFT X Gold campaign or OpenWallet Open, please contact your relationship manager, or leave a messages in our ")
                .font(Font.custom("SFProText-Light", size: FontSize.body))
            + Text("[Help center](https://www.xxx.com)")
                .font(Font.custom("SFProText-Medium", size: FontSize.body))
                .underline()
            + Text(".")
                .font(Font.custom("SFProText-Light", size: FontSize.body))
            
            NavigationLink(destination: HelpCenterView().modifier(HideNavigationBar()),
                           isActive: $navigate) {
                EmptyView()
            }
        }
        .accessibilityHint("Click to go to help center.")
        .foregroundColor(.black)
        .accentColor(Color("#333333"))
        .environment(\.openURL, OpenURLAction { _ in
            OHLogInfo("Click to go to help center.")
            navigate = true
            return .handled
        })
    }
    
    func helpMessagesForSubmittionConfirmed() -> some View {
        Text("Your request to redeem your Gold Gift and initiate the creation of an NFT for OpenWallet is confirmed.\nYou will be contacted soon to arrange delivery of your Gold Gift.\n\nIf you have any question, please contact your relationship manager.")
            .font(Font.custom("SFProText-Light", size: FontSize.body))
    }

}

struct GoldGiftGiftingRecord_Previews: PreviewProvider {
    
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

    static var previews: some View {
        GoldGiftGiftingRecord(assetDetails: assetDetails)
    }
}
