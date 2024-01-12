//
//  VideoLoopShowPlayer.swift
//  OpenWallet
//
//  Created by TQ on 2022/10/20.
//

import SwiftUI
import AVKit
import AVFoundation

struct VideoLoopShowPlayer: UIViewRepresentable {
    let url: URL
    var isPause: Bool = false
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<VideoLoopShowPlayer>) {
        OHLogInfo("VideoLoopShowPlayer pause ? \(isPause)")
        
        guard let view = uiView as? LoopingPlayerUIView else {
            return
        }
        
        if isPause == true {
            view.player.pause()
        } else {
            view.player.play()
        }
    }

    func makeUIView(context: Context) -> UIView {
        let v: LoopingPlayerUIView = LoopingPlayerUIView(frame: .zero)
        v.setURL(url: url)
        return v
    }
}

class LoopingPlayerUIView: UIView {
    var player = AVQueuePlayer()
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setURL(url: URL) {
        // Load the resource
        let fileUrl = url
        let asset = AVAsset(url: fileUrl)
        let item = AVPlayerItem(asset: asset)
        
        // Setup the player
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
         
        // Create a new player looper with the queue player and template item
        playerLooper = AVPlayerLooper(player: player, templateItem: item)

        // Start the movie
        player.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
