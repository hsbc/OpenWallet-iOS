//
//  LearnArticleView.swift
//  OpenWalletStaff
//
//  Created by LuoYao on 2022/9/19.
//

import SwiftUI

struct LearnArticleView: View {
    @Environment(\.dismiss) var dismiss
    @State var showSignRedirect: Bool = false
    @ObservedObject var learnAricleViewModel = LearnArticlesViewModel()
    
    var article: LearnArticleModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 0) {
                Image(article.headerImageLink)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, alignment: .topLeading)
                    .aspectRatio(contentMode: .fit)
                
                HStack {
                    Text(String(article.subTitle))
                        .frame(width: UIScreen.screenWidth*0.914, alignment: .leading)
                        .font(Font.custom("SFProText-Regular", size: FontSize.info))
                        .foregroundColor(Color("#333333"))
                        .lineSpacing(8)
                }
                .padding(.top, 12)
                .padding(.bottom, 24)
                
                VStack(spacing: 0) {
                    ForEach(article.subjects) { subject in
                        
                        if subject.imageLinks.count > 0 {
                            Image(subject.imageLinks.first!)
                                .resizable()
                                .scaledToFit()
                                .accessibilityLabel("")
                                .accessibilityHint("")
                                .padding(.top, 12)
                                .padding(.bottom, 12)
                        }
                        VStack {
                        Text(subject.subTitle)
                            .frame(width: UIScreen.screenWidth*0.914, alignment: .leading)
                            .font(Font.custom("SFProDisplay-Regular", size: FontSize.title2))
                            .foregroundColor(Color("#333333"))
                        }
                        .padding(.top, 12)
                        .padding(.bottom, subject.paragraphs.count > 0 ? 12 : 0)
                        
                        ForEach(subject.paragraphs) { paragraph in
                            if paragraph.paragraphTitle.count > 0 {
                                Text(paragraph.paragraphTitle)
                                    .frame(width: UIScreen.screenWidth*0.914, alignment: .leading)
                                    .font(Font.custom("SFProText-Medium", size: FontSize.body))
                                    .foregroundColor(Color("#333333"))
                                    .lineSpacing(4)
                                    .padding(.bottom, 12)
                            }
                            Text(paragraph.content)
                                .frame(width: UIScreen.screenWidth*0.914, alignment: .leading)
                                .font(Font.custom("SFProText-Regular", size: FontSize.body))
                                .foregroundColor(Color("#333333"))
                                .lineSpacing(4)
                                .padding(.bottom, 12)
                            if paragraph.imageLinks.count > 0 {
                                Image(paragraph.imageLinks.first!)
                                    .resizable()
                                    .scaledToFit()
                                    .accessibilityLabel("")
                                    .accessibilityHint("")
                                    .padding(.top, 18)
                                    .padding(.bottom, 30)
                            }
                        }
                    }
                }
                Spacer()
            }
        }.viewAppearLogger(self, info: ["id": article.id, "title": article.title])
    }
}

struct LearnArticleView_Previews: PreviewProvider {
    static var previews: some View {
        LearnArticleView(
            article:
                LearnArticleModel(
                    id: 1,
                    subTitle: "Discover the next generation of the internet with OpenWallet.",
                    title: "What is Web 3.0",
                    subjects: [
                        SubjectModel(
                            id: 1, imageLinks: [],
                            subTitle: "Know about the Web 3.0",
                            paragraphs: [
                            ]
                        ),
                        SubjectModel(
                            id: 2, imageLinks: [],
                            subTitle: "Know about the Web 3.0 revolution? ",
                            paragraphs: [
                                ParagraphModel(
                                    id: 3, paragraphTitle: "", content: "NFTs – or Non-fungible Tokens – are unique digital assets stored on the blockchain. They are designed to be unique to you and cannot be exchanged for another equivalent; unlike crypto-assets like Bitcoin or Central Bank Digital Currencies.  ",
                                    imageLinks: ["Learn1-img1"]
                                ),
                                ParagraphModel(
                                    id: 4, paragraphTitle: "", content: "NFTs – or Non-fungible Tokens – are unique digital assets stored on the blockchain. They are designed to be unique to you and cannot be exchanged for another equivalent; unlike crypto-assets like Bitcoin or Central Bank Digital Currencies.  ",
                                    imageLinks: []
                                )
                            ]
                        ),
                        SubjectModel(
                            id: 12, imageLinks: ["Learn1-img1"],
                            subTitle: "Know about the Web 3.0 revolution?",
                            paragraphs: [
                                ParagraphModel(
                                    id: 13, paragraphTitle: "1.paragraphTitle", content: "NFTs – or Non-fungible Tokens – are unique digital assets stored on the blockchain. They are designed to be unique to you and cannot be exchanged for another equivalent; unlike crypto-assets like Bitcoin or Central Bank Digital Currencies.  ",
                                    imageLinks: []
                                ),
                                ParagraphModel(
                                    id: 14, paragraphTitle: "", content: "NFTs – or Non-fungible Tokens – are unique digital assets stored on the blockchain. They are designed to be unique to you and cannot be exchanged for another equivalent; unlike crypto-assets like Bitcoin or Central Bank Digital Currencies.  ",
                                    imageLinks: []
                                )
                            ]
                        )
                    ],
                    bannerImageLink: "learn-banner1",
                    headerImageLink: "Learn1-img1")
        )
    }
}
