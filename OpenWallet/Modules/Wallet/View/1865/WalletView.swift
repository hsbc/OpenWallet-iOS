//
//  WalletView.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 5/24/22.
//

import SwiftUI

struct WalletView: View {
    @ObservedObject var user: User = User.shared
    @ObservedObject var walletAsset: WalletAsset = WalletAsset.shared
    
    var body: some View {
        if !user.isLoggin {
            SignInRedirector()
        } else {
            ZStack {
                if walletAsset.isShowLoading {
                    ProgressView()
                        .scaleEffect(2)
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                } else {
                    ScrollView {
                        nftView()
                    }
                }
            }
        }
    }

}

extension WalletView {
    
    func nftView()-> some View {
        ForEach(Array(walletAsset.IPFSResults.keys), id: \.self) { tokenID in
        
            NavigationLink {
                if walletAsset.IPFSResults[tokenID] != nil && walletAsset.tokenIds[tokenID] != nil {
                    NFTDetailView(name: walletAsset.IPFSResults[tokenID]!.name, description: walletAsset.IPFSResults[tokenID]!.description, tokenID: String(walletAsset.tokenIds[tokenID]!), imagePath: walletAsset.IPFSResults[tokenID]!.image.path)
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                }
            } label: {
                VStack(alignment: .leading, spacing: 0) {

                    URLImage(url: walletAsset.IPFSResults[tokenID]!.image.path)
                        .frame(maxWidth: UIScreen.screenWidth*0.914)

                    Spacer()
                    Group {
                        Text(walletAsset.IPFSResults[tokenID]!.name)
                            .font(Font.custom("SFProText-Medium", size: FontSize.body))
                        Text("NFT Tokenization ID: \(String(walletAsset.tokenIds[tokenID] == nil ? "" : walletAsset.tokenIds[tokenID]!))")
                            .font(Font.custom("SFProText-Regular", size: FontSize.info))
                            .padding(.bottom)
                    }.padding(.leading)
                }
                .frame(width: UIScreen.screenWidth*0.914, height: UIScreen.screenHeight*0.294)
                .border(Color("#ededed"), width: 1)
            }

        }
    }
}

struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
    }
}
