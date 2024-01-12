//
//  AssetPreloader.swift
//  OpenWallet
//
//  Created by TQ on 2022/10/21.
//

import Foundation

@MainActor
class AssetPreloader: ObservableObject {
    static let shared = AssetPreloader()
    
    let loader = AssetLoader()
    
    func preload(urls: [String]) async {
        for url in urls {
            OHLogInfo("AssetPreloader start preload url \(url)")
            do {
                try await loader.fetch(url, User.shared.token, judgeExtension(url: url))
            } catch {
                OHLogInfo("AssetPreloader preload url error \(url) \(error)")
            }
        }
    }
}
