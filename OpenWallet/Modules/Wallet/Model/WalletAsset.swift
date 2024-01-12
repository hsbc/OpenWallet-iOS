//
//  WalletAsset.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/8/3.
//

import Foundation

class WalletAsset: ObservableObject {
    static let shared = WalletAsset()

    static let assets = NSCache<NSString, NFTBasicInfo>()
    static let assetsDetails = NSCache<NSString, NFTTokenDetails>()
    
    @Published var IPFSResults: [String: IpfsResult] = [:]
    @Published var tokenIds: [String: String] = [:]
    @Published var isShowLoading = true
    
    func addAsset(_ asset: NFTBasicInfo) {
        Self.assets.setObject(asset, forKey: String(asset.nftId) as NSString)
    }
    
    func addAssetDetails(_ tokenURI: String, _ assetDetails: NFTTokenDetails) {
        Self.assetsDetails.setObject(assetDetails, forKey: tokenURI as NSString)
    }
    
    func findAsset(_ assetId: Int) -> NFTBasicInfo? {
        if let asset = Self.assets.object(forKey: String(assetId) as NSString) {
            OHLogInfo("Get asset from cache.")
            return asset
        }

        return nil
    }
    
    func findAssetDetails(_ tokenURI: String) -> NFTTokenDetails? {
        if let assetDetails = Self.assetsDetails.object(forKey: tokenURI as NSString) {
            OHLogInfo("Get asset details from cache.")
            return assetDetails
        }
        
        return nil
    }

    func removeCachedAssets() {
        OHLogInfo("Remove cached assets")
        Self.assets.removeAllObjects()
    }
    
    func removeCashedAssetsDetails() {
        OHLogInfo("Remove cached assets details")
        Self.assetsDetails.removeAllObjects()
    }
}
