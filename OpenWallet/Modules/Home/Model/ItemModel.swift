//
//  ItemModel.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/6.
//

import Foundation
import SwiftUI

struct ItemModel: Hashable, Codable, Identifiable {
    var id: Int
    
    private var imageName: String
    var image: Image {
        Image(imageName)
    }

    var itemName: String
}
