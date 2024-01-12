//
//  NFTDetailView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/19.
//

import SwiftUI

struct NFTDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State var isMore = false
    
    var name: String
    var description: String
    var tokenID: String
    var imagePath: String
    
    var body: some View {
        ZStack {
            VStack {
                TopBarView(title: "NFT detail", backAction: { dismiss() })
                    .padding(.horizontal, UIScreen.screenWidth*0.029)
                    .padding(.top, UIScreen.screenHeight*0.0136)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        URLImage(url: imagePath)
                            .frame(maxWidth: .infinity, minHeight: UIScreen.screenHeight*0.287, maxHeight: UIScreen.screenHeight*0.287)
                        
                        Group {
                            Text(name)
                                .font(Font.custom("SFProDisplay-Regular", size: FontSize.title1))
                                .padding(.top, UIScreen.screenHeight*0.043)
                            Text("NFT Tokenization ID: \(tokenID)")
                                .font(Font.custom("SFProText-Regular", size: FontSize.body))
                            
                            HStack {
                                Image(systemName: "doc.text")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: UIScreen.main.bounds.height*0.02, alignment: .center)
                                Text("Background")
                                    .font(Font.custom("SFProText-Regular", size: FontSize.body))
                                Spacer()
                            }.frame(maxWidth: .infinity)
                                .padding(.top, UIScreen.screenHeight*0.021)
                                .padding(.bottom, UIScreen.screenHeight*0.01)
                            
                            Text(description)
                                .font(Font.custom("SFProText-Light", size: FontSize.info))
                                .frame(maxWidth: UIScreen.screenWidth*0.941, alignment: .leading)

                        }.padding(.leading, UIScreen.screenWidth*0.042)
                    }
                    
                }
                
                Spacer()
            }
        }
    }
}

struct NFTDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NFTDetailView(name: "1865NFT", description: "This is the description", tokenID: "23", imagePath: "https://ipfs.infura-ipfs.io/ipfs/QmTdSqeUqEpSdfrNyR1zUsnK1YkFXpmv1LT8F3JF2bmrtv")
    }
}
