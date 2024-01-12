//
//  ImageLoader.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/8/3.
//

import Foundation
import SwiftUI

enum NetworkError: Error {
    case badRequest
    case unsupportedImage
    case badUrl
}

@MainActor
class ImageLoader: ObservableObject {
    @Published var uiImage: UIImage?
    @Published var isLoadingImage: Bool = false
    @Published var failedToLoadImage: Bool = false
    
    private static let cache = NSCache<NSString, UIImage>()
    
    let ipfsService: IpfsService
    let nftService: NFTService
    
    init(ipfsService: IpfsService = IpfsService(), nftService: NFTService = NFTService()) {
        self.ipfsService = ipfsService
        self.nftService = nftService
    }
    
    func fetchImage(_ url: String) async throws {
        // check in cache
        if let cachedImage = Self.cache.object(forKey: url as NSString) {
            OHLogInfo("get from cache")
            
            uiImage = cachedImage
        } else {
            do {
                isLoadingImage = true

                OHLogInfo("get remote image")
                let data = try await ipfsService.getIpfsImg(url)
                guard data != nil else {
                    throw NetworkError.badRequest
                }
                
                guard let image = UIImage(data: data!) else {
                    throw NetworkError.unsupportedImage
                }
                
                // store it in the cache
                image.imageData = data
                Self.cache.setObject(image, forKey: url as NSString)
                uiImage = image
                
                isLoadingImage = false
            } catch let error {
                isLoadingImage = false
                failedToLoadImage = true
                OHLogInfo("ImageLoader error: \(error)")
                throw NetworkError.badRequest
            }
        }
    }
    
    func fetchImage(_ imageUri: String, _ userToken: String) async throws {
        if let cachedImage = Self.cache.object(forKey: imageUri as NSString) {
            uiImage = cachedImage
        } else {
            do {
                isLoadingImage = true

                let imageData = try await nftService.getNFTTokenImage(imageUri, userToken)
                
                guard let image = UIImage(data: imageData) else {
                    throw NetworkError.unsupportedImage
                }
                
                // store it in the cache
                image.imageData = imageData
                Self.cache.setObject(image, forKey: imageUri as NSString)
                uiImage = image
                
                isLoadingImage = false
            } catch {
                isLoadingImage = false
                failedToLoadImage = true
                OHLogInfo("ImageLoader error: \(error)")
                throw NetworkError.badRequest
            }
        }
    }
}
