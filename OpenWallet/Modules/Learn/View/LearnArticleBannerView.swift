//
//  LearnArticleBannerView.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/9/20.
//

import SwiftUI

struct LearnArticleBannerView: View {
    var article: LearnArticleModel
    var body: some View {
        ZStack {
            VStack {
                Color.clear
                Spacer()
            }
            .border(Color("#ededed"), width: 1)
            .frame(width: UIScreen.main.bounds.width*0.914, height: UIScreen.main.bounds.height*0.294)
            
            VStack(alignment: .leading, spacing: 0) {
                if article.bannerImageLink.count>0 {
                    Image(article.bannerImageLink)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: UIScreen.screenHeight*0.914)
                        .accessibilityHidden(true)
                        .background(Color.clear)
                }
                
                Text(article.title)
                    .font(Font.custom("SFProText-Medium", size: FontSize.body))
                    .foregroundColor(Color("#333333"))
                    .padding(.top, UIScreen.screenHeight*0.016)
                    .padding(.leading, UIScreen.screenWidth*0.042)
                
                Text(article.subTitle)
                    .font(Font.custom("SFProText-Regular", size: FontSize.label))
                    .foregroundColor(Color("#333333"))
                    .padding(.top, 4)
                    .padding(.leading, UIScreen.screenWidth*0.042)
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width*0.914, height: UIScreen.main.bounds.height*0.294, alignment: .leading)
        }
    }
}

struct LearnArticleBannerView_Previews: PreviewProvider {
    static var previews: some View {
        LearnArticleBannerView(article:
                                LearnArticleModel(
            id: 1,
            subTitle: "Discover the next generation of the internet with OpenWallet.",
            title: "What is Web 3.0",
            subjects: [],
            bannerImageLink: "learn-banner1",
            headerImageLink: "Learn1-img1")
        )
    }
}
