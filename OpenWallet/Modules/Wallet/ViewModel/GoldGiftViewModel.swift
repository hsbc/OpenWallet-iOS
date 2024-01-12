//
//  GoldGiftViewModel.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/8.
//

import Foundation
import SwiftUI

@MainActor
class GoldGiftViewModel: ObservableObject {
    @Published var asset: NFTBasicInfo
    @Published var assetDetails: NFTTokenDetails
    @Published var customerBankInfo: CustomerBankInfo
    
    @Published var isActiveRedeemFirst: Bool = false
    @Published var isActiveSuccessRedeem: Bool = false
    @Published var isActiveRedeemFailed: Bool = false
    
    @Published var navigateToConfirmRedemption: Bool = false
    @Published var isCreatingRedemptionRequest: Bool = false

    @Published var isFetchingDeliveryInfo: Bool = false
    @Published var failedToFetchDeliveryInfo: Bool = false
    @Published var showFailedToFetchDeliveryInfoNotification: Bool = false
    @Published var failedToFetchDeliveryInfoNotificationMessage: String = AppState.defaultErrorMesssage

    @Published var backToNFTDetail: Bool = false
    @Published var backToWalletMain: Bool = false
    
    @Published var ReceiverName: String = ""
    @Published var countryCode: String = "65"
    @Published var phoneNum: String = ""
    @Published var addr1: String = ""
    @Published var addr2: String = ""
    @Published var postCode: String = ""
    
    @Published var isLoadingAssets: Bool = false
    @Published var isLoadingAssetDetails: Bool = true
    
    @Published var failedToLoaddAssets: Bool = false
    @Published var showFailedToLoadAssetsAlert: Bool = false
    @Published var failedToLoadAssetsMessage: String = AppState.defaultErrorMesssage

    @Published var failedToLoadAssetDetails: Bool = false
    @Published var showFailedToLoadAssetDetailsAlert: Bool = false
    @Published var failedToLoadAssetDetailsMessage: String = AppState.defaultErrorMesssage
    
    @Published var navigateToHomePage: Bool = false
    @Published var navigateToErrorPage: Bool = false
    @Published var navigateToErrorPageFromGiftPreviewPage: Bool = false
    @Published var navigateToErrorPageFromRedeemPage: Bool = false
    
    private var nftService: NFTService
    private var bankService: BankService
    private var deliveryService: DeliveryService
    
    init(
        nftService: NFTService = NFTService(),
        bankService: BankService = BankService(),
        deliveryService: DeliveryService = DeliveryService(),
        asset: NFTBasicInfo = NFTBasicInfo(imageURI: [], tokenURI: "", datetime: 0, name: "", nftId: -1, edition: "", ownedBy: "", status: .redeemable),
        assetDetails: NFTTokenDetails = NFTTokenDetails(name: "", material: "", fineness: "", weight: "", goldItemInformation: "", imageList: [""], ownedBy: "", status: .redeemable, datetime: 0, serialNumber: nil),
        customerBankInfo: CustomerBankInfo = CustomerBankInfo(legalName: "", phoneCountryCode: "", phoneNumber: "")
    ) {
        self.nftService = nftService
        self.bankService = bankService
        self.deliveryService = deliveryService
        self.asset = asset
        self.assetDetails = assetDetails
        self.customerBankInfo = customerBankInfo
    }
    
    func resetRedeemData() {
        ReceiverName = ""
        countryCode = "65"
        phoneNum = ""
        addr1 = ""
        addr2 = ""
        postCode = ""
    }
    
    func removeCachedAssets() {
        WalletAsset.shared.removeCachedAssets()
    }
    
    func removeCachedAssetsDetails() {
        WalletAsset.shared.removeCashedAssetsDetails()
    }
    
    func getWalletAssets(_ userToken: String) async {
        guard let firstAsset = WalletAsset.shared.findAsset(asset.nftId) else {
            await fetchWalletAssets(userToken)
            
            if let result = WalletAsset.shared.findAsset(asset.nftId) {
                asset = result
            }
            
            return
        }
        
        asset = firstAsset
    }
    
    func fetchWalletAssets(_ userToken: String) async {
        do {
            OHLogInfo("Fetch asset.")
            if !isLoadingAssets {
                isLoadingAssets = true
            }

            let assets = try await nftService.getNFTs(userToken)
            
            for asset in assets {
                WalletAsset.shared.addAsset(asset)
                
                let preloadUrls = asset.imageURI.filter({ url in
                        // feature: ignore webp which is using by Android, and ignore placeholder to have another logic
                        if url.contains(".webp") || url.contains("placeholder") {
                            return false
                        }
                        return true
                    })
                
                await AssetPreloader.shared.preload(urls: preloadUrls)
            }

            // set the first asset as target asset. [weihao.zhang]
            if let firstAsset = assets.first, !assets.isEmpty {
                asset = firstAsset
            }

            if failedToLoaddAssets {
                failedToLoaddAssets = false
            }
            
            isLoadingAssets = false
        } catch let apiErrorResponse as ApiErrorResponse {
            OHLogInfo("Failed to fetch asset. API error response.")
            OHLogInfo(apiErrorResponse)
            failedToLoaddAssets = true
            failedToLoadAssetsMessage = apiErrorResponse.message ?? AppState.defaultErrorMesssage
            showFailedToLoadAssetsAlert = true
            isLoadingAssets = false
        } catch {
            OHLogInfo("Failed to fetch asset. Unexpected error.")
            OHLogInfo(error)
            failedToLoaddAssets = true
            navigateToErrorPage = true
            isLoadingAssets = false
        }
    }

    func getAssetDetails(_ asset: NFTBasicInfo, _ userToken: String) async {
        guard let assetDetails = WalletAsset.shared.findAssetDetails(asset.tokenURI) else {
            await fetchAssetDetails(asset, userToken)
            
            if let assetDetails = WalletAsset.shared.findAssetDetails(asset.tokenURI) {
                self.assetDetails = assetDetails
            }

            return
        }
        
        self.assetDetails = assetDetails

        if isLoadingAssetDetails {
            isLoadingAssetDetails = false
        }
    }
    
    func fetchAssetDetails(_ asset: NFTBasicInfo, _ userToken: String) async {
        do {
            OHLogInfo("Fetch asset details.")
            if !isLoadingAssetDetails {
                isLoadingAssetDetails = true
            }

            let assetDetails = try await nftService.getNFTTokenDetails(asset.tokenURI, userToken)
            WalletAsset.shared.addAssetDetails(asset.tokenURI, assetDetails)

            if failedToLoaddAssets {
                failedToLoadAssetDetails = false
            }
            
            isLoadingAssetDetails = false
        } catch let apiErrorResponse as ApiErrorResponse {
            OHLogInfo("Failed to fetch asset details. API error response.")
            OHLogInfo(apiErrorResponse)
            failedToLoadAssetDetails = true
            failedToLoadAssetDetailsMessage = apiErrorResponse.message ?? AppState.defaultErrorMesssage
            showFailedToLoadAssetDetailsAlert = true
            isLoadingAssetDetails = false
        } catch {
            OHLogInfo("Failed to fetch asset details. Unexpected error.")
            OHLogInfo(error)
            failedToLoadAssetDetails = true
            navigateToErrorPageFromGiftPreviewPage = true
            isLoadingAssetDetails = false
        }
    }
    
    func getDeliveryInfo(_ userToken: String) async {
        do {
            if !isFetchingDeliveryInfo {
                isFetchingDeliveryInfo = true
            }
            
            customerBankInfo = try await bankService.getBankInfo(userToken)

            isFetchingDeliveryInfo = false
        } catch let apiErrorResponse as ApiErrorResponse {
            OHLogInfo(apiErrorResponse)
            failedToFetchDeliveryInfo = true
            failedToFetchDeliveryInfoNotificationMessage = apiErrorResponse.message ?? AppState.defaultErrorMesssage
            showFailedToFetchDeliveryInfoNotification = true
            isFetchingDeliveryInfo = false
        } catch {
            OHLogInfo(error)
            failedToFetchDeliveryInfo = true
            navigateToErrorPageFromRedeemPage = true
            isFetchingDeliveryInfo = false
        }
    }
    
    func submitRedemptionRequest(_ nftId: Int, _ userToken: String) async {
        do {
            isCreatingRedemptionRequest = true
            isActiveSuccessRedeem = try await deliveryService.createDelivery(nftId, userToken)
            isCreatingRedemptionRequest = false
        } catch {
            OHLogInfo(error)
            isCreatingRedemptionRequest = false
            isActiveRedeemFailed = true
        }
    }
    
}
