//
//  UaeHome.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/8/24.
//

import SwiftUI

struct UaeHome: View {
    @ObservedObject var notificationManager: NotificationManager = NotificationManager.shared

    private let nftService: NFTService = NFTService()
    
    @State var articlesList: [LearnArticleModel] = []
    
    @State var templates: [CarouselTemplate] = []
    
    var body: some View {
        ZStack {
            // background
            VStack {
                Image("headers-bg")
                    .resizable()
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight * 0.313, alignment: .top)
                    .border(Color("#252525"), width: 1)
                
                Spacer()
            }
            .ignoresSafeArea()
            .accessibilityHidden(true)
            
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    headerBar()
                    Text("Good \(Date.now.toTimeOfDay)")
                        .foregroundColor(.white)
                        .font(Font.custom("SFProDisplay-Regular", size: FontSize.largeHeadline))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom, UIScreen.screenHeight * 0.02)
                .padding(.horizontal, UIScreen.screenWidth * 0.043)
                
                ScrollView(showsIndicators: false) {
                    HStack {
                        VStack(spacing: UIScreen.screenHeight * 0.019) {
                            banner()
                            if User.shared.remindExpiringToken &&
                               !User.shared.disableRemindExpiringToken {
                                notificationBoard()
                            }
                            
                            learnCarousel()
                        }.padding(.horizontal, UIScreen.screenWidth * 0.043)
                        
                    }
                }
                .introspectScrollView { scrollView in
                    scrollView.alwaysBounceVertical = false
                }
                
                Spacer()
            }
        }
        .viewAppearLogger(self)
        .onAppear {
            guard User.shared.isLoggin else { return }

            articlesList = JsonLoader.load("LearnArticlesData.json")
            templates = self.articlesList.map { (article: LearnArticleModel) -> CarouselTemplate in
               let naviButton = NavigationButton(
                 action: { },
                 destination: { LearnArticleView(article: article)
                                         .navigationBarTitle(article.title)
                                         .navigationBarTitleDisplayMode(.inline) },
                 content: { LearnArticleBannerView(article: article) }
               )
               
               let template = CarouselTemplate(view: AnyView(naviButton))
               return template
           }
            
            Task {
                do {
                    User.shared.remindExpiringToken = try await nftService.hasExpiringToken(User.shared.token)
                    
                    print("User.shared.remindExpiringToken: \(User.shared.remindExpiringToken)")
                    
                    _ = try await NotificationManager.shared.getNotificaitons(User.shared.token)
                } catch {
                    OHLogInfo(error)
                }
            }
        }
    }
}

extension UaeHome {

    func headerBar() -> some View {
        HStack {
            Spacer()
            
            NavigationLink(
                destination: NotificationView().modifier(HideNavigationBar())
            ) {
                VStack {
                    Image("Icon-notification")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .overlay(notificationManager.hasUnreadNotification ? Badge() : nil)
                }
                .frame(width: UIScreen.screenWidth * 0.117, height: UIScreen.screenWidth * 0.117)
                .background(.white)
                .clipShape(Circle())
                .padding(.trailing, 0)
            }
            .accessibilityElement(children: .combine)
            .accessibilityHint("Click to go to notification page.")
        }
    }
    
    func banner() -> some View {
        ZStack {
            VStack {
                Spacer()
                Color.clear
            }
            .border(Color("#ededed"), width: 1)
            .frame(height: 219)
            
            VStack(alignment: .leading) {
                Image("home-banner")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.screenWidth * 0.914)
                    .padding(.top, 0)
                Text("OpenWallet Gold X NFT - Gold Gift is ready to be redeemed!")
                    .font(Font.custom("SFProText-Medium", size: FontSize.body))
                    .foregroundColor(Color("#333333"))
                    .padding(.leading, 16)
                Spacer()
            }
            .frame(height: 219)
            .accessibilityLabel("NFT is assigned to you")
            .accessibilityHint("Click to go to Wallet page.")
            .onTapGesture {
                AppState.shared.selectedTab = Tab.wallet
                OHLogInfo(UIScreen.screenHeight)
            }
        }.background(Color.white)
    }
    
    func notificationBoard() -> some View {
        VStack {
            HStack(spacing: UIScreen.screenWidth * 0.0) {
                Image("Icon-gift")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.screenWidth * 0.149)
                    .padding(.leading, UIScreen.screenWidth * 0.043)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("Gold X NFT - Gold Gift is about to expire.")
                        .font(Font.custom("SFProText-Medium", size: FontSize.body))
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(4)
                    
                    Text("Redeem your Gold Gift now!")
                        .font(Font.custom("SFProText-Light", size: FontSize.info))
                        .foregroundColor(Color("#333333"))
                        .padding(.top, 4)
                }
                .padding(.leading, UIScreen.screenWidth * 0.069)
                .padding(.trailing, UIScreen.screenWidth * 0.082)
                Spacer()
            }
            .frame(width: UIScreen.screenWidth * 0.915, height: UIScreen.screenSize.height * 0.124)
            .border(Color("#ededed"), width: 1)
            .overlay(alignment: .topTrailing) {
                Button {
                    User.shared.disableRemindExpiringToken = true
                } label: {
                    Image("Close")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.screenWidth * 0.04, height: UIScreen.screenWidth * 0.04)
                        .padding([.top, .trailing], UIScreen.screenWidth * 0.033)
                }
                .accessibilityHint("Click to close notification.")
            }
        }.background(Color.white)
    }
    
    func learnCarousel() -> some View {
        VStack(spacing: UIScreen.screenHeight * 0.01) {
            Text("Learn")
                .foregroundColor(Color("#333333"))
                .font(Font.custom("SFProDisplay-Regular", size: FontSize.title4))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 11)
                .padding(.top, (User.shared.remindExpiringToken && !User.shared.disableRemindExpiringToken) ? 0 : UIScreen.screenHeight * 0.009)
            
            CarouselNew(
                templates,
                horPadding: 0,
                horInset: 9,
                containerWidth: UIScreen.screenWidth,
                containerHeight: UIScreen.screenHeight * 0.294,
                itemWidth: UIScreen.screenWidth - Constants.horPadding * 2,
                itemBackground: Color.clear,
                indicatorHeight: 6,
                loopType: .round,
                showArrow: false,
                strokeLineWidth: 0,
                indicatorNormalColor: Color("#d7d8d6"),
                indicatorSelectedColor: Color("#db0011"),
                indicatorNormalSize: CGSize(width: 6, height: 6),
                indicatorSelectedSize: CGSize(width: 6, height: 6),
                indicatorTopPadding: 16
            ).padding(.bottom, 20)
        }
    }
}

struct UaeHome_Previews: PreviewProvider {
    static var previews: some View {
        UaeHome()
    }
}
