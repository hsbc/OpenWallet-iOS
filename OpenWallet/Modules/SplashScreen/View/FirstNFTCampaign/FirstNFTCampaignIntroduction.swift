//
//  FirstNFTCampaignIntroduction.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/8/22.
//

import SwiftUI

struct FirstNFTCampaignIntroduction: View {
    @ObservedObject var splashScreenManager: SplashScreenManager = SplashScreenManager.shared
    
    @State var navigateToLearnModule: Bool = false
    @State var redirectToLogOn: Bool = false
    
    @State var isTermsAndConditionsAccepted: Bool = false
    
    private var campaignIntroDigitiseAtScaleInfoPartOne: String = "OpenWallet has been developing and deploying some of the industry’s most advanced and innovative technology to make customers’ banking easier and more secure."
    private var campaignIntroDigitiseAtScaleInfoPartTwo: String = "Digital assets could unlock a range of untapped opportunities in our financial services and enable us to deliver new long term sustainable value to customers, whether they’re a first-time saver, a budding start-up or a multi-national business."
    private var campaignIntroDigitiseAtScaleInfoPartThree: String = "One of our latest digital innovations is putting our power in building the non-fungible token capability with robust risk management."
    
    private var joinUsInfoPartOne: String = "We’re excited to let you be among the first across OpenWallet’s international network to experience our digital wallet – \(EnvironmentConfig.appDisplayName), learn about a few key concepts of digital assets, test your knowledge and get a chance to"
    private var joinUsInfoPartTwo: String = "win one of 1,000 bespoke OpenWallet NFT"
    private var joinUsInfoPartThree: String = "(non-fungible tokens)!"
    
    var body: some View {
        VStack(alignment: .center) {
            ScrollView {
                VStack(spacing: 0) {
                    helloNFTSection()

                    GifImage(name: "Campaign Introduction Page-kv")
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width)
                        .accessibilityElement()
                        .accessibilityLabel("Campaign introduction GIF image.")
                        .accessibilityAddTraits(.isImage)

                    VStack(spacing: 20) {
                        digitiseAtScaleSection()
                        joinUsToTestAndLearnSection()
                    }
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.088)

                    GifImage(name: "Campaign Introduction Page-nft")
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width)
                        .accessibilityElement()
                        .accessibilityLabel("OpenWallet NTF GIF image.")
                        .accessibilityAddTraits(.isImage)
                    
                    howToWinTheNFTSection()
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.088)
                }
                
                HStack(spacing: 6.33) {
                    ZStack {
                        if isTermsAndConditionsAccepted {
                            Image(systemName: "checkmark")
                        }
                    }
                    .frame(width: 14, height: 14)
                    .border(Color("#d4d4d4"), width: 1)

                    Text("Terms and conditions.")
                        .font(Font.custom("SFProText-Light", size: FontSize.caption))
                    Spacer()
                }
                .onTapGesture {
                    isTermsAndConditionsAccepted.toggle()
                }
                .accessibilityElement(children: .combine)
                .accessibilityHint("Click to accept terms and conditions")
                .padding(.top, 28.33)
                .padding(.horizontal, UIScreen.main.bounds.width * 0.088)
            }
            .padding(.bottom)
            
            Spacer()
            
            Group {
                NavigationLink(
                    destination: SignInRedirector().modifier(HideNavigationBar()),
                    isActive: $redirectToLogOn
                ) {
                    EmptyView()
                }
                
                NavigationLink(
                    destination: MainView().modifier(HideNavigationBar()),
                    isActive: $navigateToLearnModule
                ) {
                    EmptyView()
                }
            }
            .accessibilityHidden(true)
            
            ActionButton(
                text: "Start the quiz",
                isDisabled: Binding<Bool>(
                    get: { !isTermsAndConditionsAccepted },
                    set: { isTermsAndConditionsAccepted = !$0 }
                )
            ) {
                AppState.shared.selectedTab = Tab.learn

                if User.shared.isLoggin {
                    navigateToLearnModule.toggle()
                } else {
                    redirectToLogOn.toggle()
                }
            }
            .disabled(!isTermsAndConditionsAccepted)
            .padding(.horizontal, UIScreen.main.bounds.width * 0.088)
            .padding(.bottom, 10)
            .accessibilityHint("Click to start the quiz. Please accept terms and conditions to enable the button.")
        }
        .background(.white)
    }
}

extension FirstNFTCampaignIntroduction {
    func helloNFTSection() -> some View {
        VStack {
            HStack {
                Text("Hello!").font(Font.custom("SFProText-Light", size: 54))
                Spacer()
            }
            
            HStack(spacing: 16) {
                Text("OpenWallet")
                    .font(Font.custom("SFProText-Light", size: 54))
                    .foregroundColor(Color("#db0011"))
                Text("NFT")
                    .font(Font.custom("SFProText-Light", size: 54))
                Spacer()
            }
            .accessibilityElement(children: .combine)
        }
        .padding(.horizontal, 50)
        .accessibilityElement(children: .combine)
    }
    
    func digitiseAtScaleSection() -> some View {
        VStack(spacing: 11) {
            HStack {
                Text("Digitise at Scale")
                    .font(Font.custom("SFProText-Bold", size: FontSize.body))
                Spacer()
            }
            .accessibilityAddTraits(.isHeader)
            
            HStack {
                Text(campaignIntroDigitiseAtScaleInfoPartOne)
                    .font(Font.custom("SFProText-Light", size: FontSize.caption))
                Spacer()
            }
            
            HStack {
                Text(campaignIntroDigitiseAtScaleInfoPartTwo)
                    .font(Font.custom("SFProText-Light", size: FontSize.caption))
                Spacer()
            }
            
            HStack {
                Text(campaignIntroDigitiseAtScaleInfoPartThree)
                    .font(Font.custom("SFProText-Light", size: FontSize.caption))
                Spacer()
            }
        }
    }
    
    func joinUsToTestAndLearnSection() -> some View {
        VStack(spacing: 7) {
            HStack {
                Text("Join us to test and learn")
                    .font(Font.custom("SFProText-Bold", size: FontSize.body))
                Spacer()
            }
            .accessibilityAddTraits(.isHeader)
            
            HStack {
                Group {
                    Text(joinUsInfoPartOne)
                        .font(Font.custom("SFProText-Light", size: FontSize.caption)) +
                    Text(" \(joinUsInfoPartTwo) ")
                        .font(Font.custom("SFProText-Bold", size: FontSize.caption))
                        .foregroundColor(Color("#db0011")) +
                    Text(joinUsInfoPartThree)
                        .font(Font.custom("SFProText-Light", size: FontSize.caption))
                }
                Spacer()
            }
        }
    }
    
    func howToWinTheNFTSection() -> some View {
        VStack(spacing: 13.67) {
            HStack {
                Text("How to win the NFT")
                    .font(Font.custom("SFProText-Bold", size: FontSize.body))
                Spacer()
            }
            .accessibilityAddTraits(.isHeader)
            
            VStack(spacing: 7.67) {
                HStack(spacing: 10) {
                    Image("ic_step1_campaign_intro")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45)
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Step 1:")
                            .font(Font.custom("SFProText-Bold", size: FontSize.caption))
                            .foregroundColor(Color("#db0011"))
                        Text("Complete the \"Digital Assets\" quiz.")
                            .font(Font.custom("SFProText-Light", size: FontSize.caption))
                    }
                    Spacer()
                }
                .padding(11)
                .border(Color("#d4d4d4"), width: 0.5)
                .accessibilityElement(children: .combine)

                HStack(spacing: 10) {
                    Image("ic_step2_campaign_intro")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45)
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Step 2:")
                            .font(Font.custom("SFProText-Bold", size: FontSize.caption))
                            .foregroundColor(Color("#db0011"))
                        Text("Enroll in the lucky draw.")
                            .font(Font.custom("SFProText-Light", size: FontSize.caption))
                    }
                    Spacer()
                }
                .padding(11)
                .border(Color("#d4d4d4"), width: 0.5)
                .accessibilityElement(children: .combine)
                
                HStack(spacing: 10) {
                    Image("ic_step3_campaign_intro")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45)
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Step 3:")
                            .font(Font.custom("SFProText-Bold", size: FontSize.caption))
                            .foregroundColor(Color("#db0011"))
                        Text("Receive notification by email.")
                            .font(Font.custom("SFProText-Light", size: FontSize.caption))
                    }
                    Spacer()
                }
                .padding(11)
                .border(Color("#d4d4d4"), width: 0.5)
                .accessibilityElement(children: .combine)
                
                HStack(spacing: 10) {
                    Image("ic_step4_campaign_intro")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45)
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Step 4:")
                            .font(Font.custom("SFProText-Bold", size: FontSize.caption))
                            .foregroundColor(Color("#db0011"))
                        Text("Collect your NFT in \"\(EnvironmentConfig.appDisplayName)\".")
                            .font(Font.custom("SFProText-Light", size: FontSize.caption))
                    }
                    Spacer()
                }
                .padding(11)
                .border(Color("#d4d4d4"), width: 0.5)
                .accessibilityElement(children: .combine)
            }
        }
    }
}

struct FirstNFTCampaignIntroduction_Previews: PreviewProvider {
    static var previews: some View {
        FirstNFTCampaignIntroduction()
    }
}
