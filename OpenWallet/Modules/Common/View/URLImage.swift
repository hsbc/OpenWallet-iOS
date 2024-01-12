//
//  URLImage.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/8/2.
//

import Foundation
import SwiftUI

struct URLImage: View {
    var url: String
    var userToken: String = ""

    @StateObject private var imageLoader = ImageLoader()
    
    var body: some View {
        Group {
            if let uiImage = imageLoader.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                Image("Image-Default")
                    .resizable()
                    .overlay {
                        ZStack {
                            if imageLoader.failedToLoadImage {
                                Text("Failed to load image.")
                            }
                            
                            if imageLoader.isLoadingImage {
                                ProgressView()
                            }
                        }
                        
                    }
            }
        }
        .task {
            await downloadImage()
        }
    }
    
    private func downloadImage() async {
        do {
            if !userToken.isEmpty {
                try await imageLoader.fetchImage(url, userToken)
            } else {
                try await imageLoader.fetchImage(url)
            }
        } catch {
            OHLogInfo(error)
        }
    }
}
