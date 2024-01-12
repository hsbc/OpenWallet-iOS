//
//  DebugRoom.swift
//  OpenWallet
//
//  Created by TQ on 2022/9/29.
//

import SwiftUI
import Kingfisher
import AVKit

struct Constants {
    static let horPadding: CGFloat = UIScreen.screenWidth * 0.043
    static let carouselRatio: CGFloat = 686.0 / 512.0
    static let indicatorHeight: CGFloat = 44.0
}

// debug stuff here
struct DebugRoom: View {
    // Image read local
//    var templates: [CarouselTemplate] = [
//        Image("NFT-detail-back").resizable(),
//        Image("NFT-details-front").resizable()
//    ].map {
//        CarouselTemplate(view: AnyView($0))
//    }
    
    // Image read local gif
//    var templates2 = [
//        GifImage(name: "NFT-test"),
//        GifImage(name: "NFT-detail-back"),
//        GifImage(name: "NFT-details-front")
//    ].map {
//        CarouselTemplate(view: AnyView($0))
//    }
    
    // Kingfisher read local gif&png mixed
//    var templates3 = [
//        KFAnimatedImage(source: .provider(LocalFileImageDataProvider(fileURL: Bundle.main.url(forResource: "NFT-test-video", withExtension: "gif")!))),
//        KFAnimatedImage(source: .provider(LocalFileImageDataProvider(fileURL: Bundle.main.url(forResource: "NFT-test-video", withExtension: "webp")!)))
//    ].map {
//        CarouselTemplate(view: AnyView($0))
//    }
    
    // Kingfisher read network gif&png mixed
//    var templates4 = [
//        KFAnimatedImage(source: .network(URL(string: "XXXXX/image.png")!))
//            .placeholder {
//            ProgressView()
//        },
//
//        KFAnimatedImage(source: .network(URL(string: "XXXXX/NFT-test.gif")!))
//        .placeholder {
//            ProgressView()
//        }
//    ].map {
//        CarouselTemplate(view: AnyView($0))
//    }
    
//    var videoAssets = [
//        VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource: "NFT-test-video", withExtension: "mp4")!))
//            .frame(width: UIScreen.screenWidth - Constants.horPadding * 2,
//                   height: (UIScreen.screenWidth - Constants.horPadding * 2) / Constants.carouselRatio - Constants.indicatorHeight, alignment: .center)
//    ].map {
//        CarouselTemplate(view: AnyView($0))
//    }
    
    var urls = [
        "https://user-images.githubusercontent.com/3258093/196608349-79ccd77b-ff77-4092-829e-a2230930adb7.png",
        "https://user-images.githubusercontent.com/3258093/196608368-028b1cfc-3000-478f-8bc7-52ee9d035a2f.png",
        "https://user-images.githubusercontent.com/3258093/196608763-f349b7af-c54f-4a19-a463-5ce6c9c7faf3.gif",
        "https://user-images.githubusercontent.com/3258093/196608520-8904390e-b005-4d3f-8f06-30d7cac57957.mp4"
    ]
    
    var player = AVPlayer()
    
    var body: some View {
        ZStack(alignment: .top) {
            NavigationView {
//                VideoLoopShowPlayer(url: Bundle.main.url(forResource: "NFT-test-video", withExtension: "mp4")!)
//                    .frame(width: UIScreen.screenWidth - Constants.horPadding * 2,
//                           height: (UIScreen.screenWidth - Constants.horPadding * 2) / Constants.carouselRatio - Constants.indicatorHeight, alignment: .center)
                    
//                VideoPlayer(player: player)
//                    .disabled(true)
//                    .frame(width: UIScreen.screenWidth - Constants.horPadding * 2,
//                           height: (UIScreen.screenWidth - Constants.horPadding * 2) / Constants.carouselRatio - Constants.indicatorHeight, alignment: .center)
//                    .onAppear {
//                      if player.currentItem == nil {
//                            let item = AVPlayerItem(url: Bundle.main.url(forResource: "NFT-test-video", withExtension: "mp4")!)
//                            player.replaceCurrentItem(with: item)
//                        }
//                        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
//                            player.play()
//                        })
//                    }
                
//                KFAnimatedImage(URL(string: urls[0]))
//                    .onSuccess { r in
//                        // r: RetrieveImageResult
//                        debugPrint("success: \(r)")
//                    }
//                    .onFailure { e in
//                        // e: KingfisherError
//                        debugPrint("failure: \(e)")
//                    }
//                    .requestModifier { r in
//                        debugPrint("requestModifier: \(r)")
//                    }
                    
                // Support Image
//                CarouselNew(
//                    urls.enumerated().map { (index, url) in
////                        let view = URLImage(url: url, userToken: User.shared.token)
//                        if index == 3 {
//                            let player: AVPlayer = AVPlayer(url: URL(string: url)!)
//                            let view: VideoPlayer = VideoPlayer(player: player)
//                            return CarouselTemplate(view: AnyView(view))
//                        } else {
//                            let view: KFAnimatedImage = KFAnimatedImage(source: .network(URL(string: url)!))
//                                .placeholder {
//                                    ProgressView()
//                                }
//                            return CarouselTemplate(view: AnyView(view))
//                        }
//                    },
//                    horPadding: 0,
//                    horInset: Constants.horPadding / 2,
//                    containerWidth: UIScreen.screenWidth - Constants.horPadding * 2,
//                    containerHeight: (UIScreen.screenWidth - Constants.horPadding * 2) / Constants.carouselRatio + Constants.indicatorHeight,
//                    itemWidth: UIScreen.screenWidth - Constants.horPadding * 2,
//                    itemBackground: Color.red,
//                    indicatorHeight: Constants.indicatorHeight
//                )
//                .padding(.horizontal, Constants.horPadding)
                
                // Support Url
//                CarouselNew(
//                    assetDetails
//                    .imageList
//                    .map {
//                        let view = URLImage(url: $0, userToken: User.shared.token)
//                        return CarouselTemplate(view: AnyView(view))
//                    },
//                    horInset: UIScreen.screenWidth * 0.043,
//                    containerHeight: UIScreen.screenHeight * 0.294
//                )
//                .accessibilityLabel("NFT carousel pictures")
            }
            .navigationBarTitle("Debug Room", displayMode: .inline)
        }
    }
}
