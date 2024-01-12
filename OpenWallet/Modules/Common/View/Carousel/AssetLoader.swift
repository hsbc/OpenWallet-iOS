//
//  AssetLoader.swift
//  OpenWallet
//
//  Created by TQ on 2022/10/19.
//

import Foundation
import SwiftUI
import CryptoKit

@MainActor
class AssetLoader: ObservableObject {
    @Published var filePath: String?
    @Published var loading: Bool = false
    @Published var fail: Bool = false
    
    let ipfsService: IpfsService
    let nftService: NFTService
    let fileManager = FileManager.default
    
    init(ipfsService: IpfsService = IpfsService(), nftService: NFTService = NFTService()) {
        self.ipfsService = ipfsService
        self.nftService = nftService
    }
    
    func fetch(_ url: String, _ token: String, _ fileExt: String) async throws {
        let documentDirectory = try fileManager.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: false)
        
        let docpath = documentDirectory.appendingPathComponent("nftDetail/")
        let start = DispatchTime.now()
        
        if !fileManager.fileExists(atPath: docpath.path) {
            do {
                try fileManager.createDirectory(atPath: docpath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                OHLogInfo("AssetLoader create path error \(docpath) \(error)")
            }
        }
        
        let name = MD5(string: url) + fileExt
        let path = docpath.appendingPathComponent(name)
        
        if fileManager.fileExists(atPath: path.path) {
            filePath = path.absoluteString
            
            let end = DispatchTime.now()
            let timeInterval = Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
            OHLogInfo("AssetLoader success read file \(path) cost \(timeInterval)")
        } else {
            do {
                loading = true
                fail = false
                
                var raw: Data?
                
                if token.count > 0 {
                    raw = try await nftService.getNFTTokenImage(url, token)
                } else {
                    raw = try await ipfsService.getIpfsImg(url)
                }
                
                guard raw != nil else {
                    markFail("AssetLoader empty data")
                    throw NetworkError.badRequest
                }
                
                do {
                    try raw!.write(to: path)
                    let timeInterval = Double(DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000_000
                    OHLogInfo("AssetLoader success save file \(path) cost \(timeInterval)")
                    
                    loading = false
                    filePath = path.absoluteString
                    
                } catch {
                    markFail("AssetLoader error save file \(path) \(error)")
                    throw NetworkError.badRequest
                }
                
            } catch let error {
                markFail("AssetLoader error: \(error)")
                throw NetworkError.badRequest
            }
        }
    }
    
    func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    func markFail(_ msg: String) {
        loading = false
        fail = true
        OHLogInfo(msg)
    }
}
