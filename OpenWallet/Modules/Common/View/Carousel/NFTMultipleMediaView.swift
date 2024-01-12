//
//  UserTokenImage.swift
//  OpenWallet
//
//  Created by TQ on 2022/10/19.
//

import Foundation
import SwiftUI
import Kingfisher
import AVKit

struct NFTMultipleMediaView: View {
    var url: String
    var userToken: String = ""
    var ext: String = ""
    
    @State private var isPause: Bool = false
    @StateObject private var loader = AssetLoader()
    
    var body: some View {
        Group {
            if let path = loader.filePath {
                if path.contains("mp4") || ext.contains("mp4") {
                    VideoLoopShowPlayer(url: URL(string: path)!, isPause: isPause)
                } else {
                    KFAnimatedImage(source: .provider(LocalFileImageDataProvider(fileURL: URL(string: path)!)))
                }
            } else {
                Image("Image-Default")
                .resizable()
                .overlay {
                    ZStack {
                        if loader.loading {
                            ProgressView()
                        } else if loader.fail {
                            Text("Failed to load image.")
                        }
                    }
                }
            }
        }
        .task {
            await assetLoader()
        }
        .onAppear {
            isPause = false
            OHLogInfo("VideoLoopShowPlayer onAppear \(isPause)")
        }
        .onDisappear {
            isPause = true
            OHLogInfo("VideoLoopShowPlayer onDisappear \(isPause)")
        }
    }
    
    private func assetLoader() async {
        do {
            try await loader.fetch(url, userToken, ext)
        } catch {
            OHLogInfo("NFTMultipleMediaView \(error)")
        }
    }
}

func judgeExtension(url: String) -> String {
    var ext = ".png"
    if url.contains(".webp") {
        ext = ".webp"
    } else if url.contains(".mp4") {
        ext = ".mp4"
    } else if url.contains(".gif") {
        ext = ".gif"
    }
    return ext
}
