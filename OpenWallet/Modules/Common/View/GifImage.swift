//
//  SwiftGif.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/8/22.
//

import Foundation
import UIKit
import SwiftUI

// Rendering GIFs in UIKIt
// Reference: https://github.com/kirualex/SwiftyGif/issues/128

struct GifImage: UIViewRepresentable {
    private let data: Data?
    private let name: String?
    private let loopCount: Int?
    @Binding var playGif: Bool
    
    init(data: Data, loopCount: Int = -1, playGif: Binding<Bool> = .constant(true)) {
        self.data = data
        self.name = nil
        self.loopCount = loopCount
        self._playGif = playGif
    }
    
    init(name: String, loopCount: Int = -1, playGif: Binding<Bool> = .constant(true)) {
        self.data = nil
        self.name = name
        self.loopCount = loopCount
        self._playGif = playGif
    }
    
    func makeUIView(context: Context) -> UIGIFImageView {
        var gifImageView: UIGIFImageView
        if let data = data {
            gifImageView = UIGIFImageView(data: data, loopCount: loopCount!, playGif: playGif)
        } else {
            gifImageView = UIGIFImageView(name: name!, loopCount: loopCount!, playGif: playGif)
        }
        return gifImageView
    }
    
    func updateUIView(_ gifImageView: UIGIFImageView, context: Context) {
        gifImageView.updateGIF(name: name ?? "", data: data, loopCount: loopCount!)
        
        if playGif {
            gifImageView.imageView.startAnimatingGif()
        } else {
            gifImageView.imageView.stopAnimatingGif()
        }
    }
}

class UIGIFImageView: UIView {
    private var image = UIImage()
    var imageView = UIImageView()
    private var data: Data?
    private var name: String?
    private var loopCount: Int?
    private var playGif: Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(name: String, loopCount: Int, playGif: Bool) {
        self.init()
        self.name = name
        self.loopCount = loopCount
        self.playGif = playGif
        self.layoutSubviews()
    }
    
    convenience init(data: Data, loopCount: Int, playGif: Bool) {
        self.init()
        self.data = data
        self.loopCount = loopCount
        self.playGif = playGif
        self.layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        self.addSubview(imageView)
    }
    
    func updateGIF(name: String, data: Data?, loopCount: Int) {
        do {
            if let data = data {
                image = try UIImage(gifData: data)
            } else {
                OHLogInfo(name)
                image = try UIImage(gifName: name)
            }
        } catch {
            OHLogInfo(error)
        }
        
        if let subview = self.subviews.first as? UIImageView {
            // if new gif, remove old to show new
            if image.imageData != subview.gifImage?.imageData {
                imageView = UIImageView(gifImage: image, loopCount: loopCount)
                imageView.contentMode = .scaleAspectFit
                subview.removeFromSuperview()
            }
        } else {
            OHLogInfo("error: no existing subview")
        }
    }
}
