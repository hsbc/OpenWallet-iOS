//
//  GoldGiftProductBackground.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/6.
//

import SwiftUI

struct GoldGiftProductBackground: View {
    @Environment(\.dismiss) var dismiss

    @State var assetDetails: NFTTokenDetails
    
    @State var backgroundContent: String = "NFTs – or Non-Fungible Tokens – are unique digital assets stored on a blockchain. They are designed to be unique and cannot be exchanged for another equivalent, unlike crypto-assets like Bitcoin or Central Bank Digital Currencies.\n\nThe NFTs can be used to represent distinct goods, such as a land title deed or a particular piece of artwork. They can be digital proof of ownership or authenticity and can even provide transferability when a physical good/service is not as easily transferable.\n\nFor this OpenWallet Open campaign, the NFT does not represent ownership of any good or service and is non-tradable, meaning you will not be able to use or sell it on a crypto exchange.\n\nHowever, you will learn more about NFTs and Web 3.0 and will play a role in OpenWallet’s creation of an NFT while you redeem your Gold Gift."
    
    var body: some View {
        VStack {
            TopBarView(title: "NFT background", backAction: { dismiss() })
                .padding(.horizontal, UIScreen.screenWidth*0.029)
                .padding(.top, UIScreen.screenHeight*0.0136)
            
            ScrollView {
                VStack(alignment: .leading, spacing: UIScreen.screenHeight*0.029) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("OpenWallet NFT ID: ")
                                .font(Font.custom("SFProText-Regular", size: FontSize.info)) +
                            Text(assetDetails.serialNumber != nil ? assetDetails.serialNumber!.addLeadingPadding("0", 10) : "N/A")
                                .font(Font.custom("SFProText-Regular", size: FontSize.info))
                        }
                        
                        HStack {
                            Text("NFT status: \(assetDetails.status.getStatusDisplayValue())")
                                .font(Font.custom("SFProText-Regular", size: FontSize.info))
                        }
                    }
                    
                    Image("NFT-img2")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: UIScreen.screenWidth)
                    
                    Text(backgroundContent)
                        .font(Font.custom("SFProText-Light", size: FontSize.body))
                }
                .padding()

            }
            Spacer()
        }
    }
}

struct GoldGiftProductBackground_Previews: PreviewProvider {
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
        GoldGiftProductBackground(assetDetails: assetDetails)
    }
}
