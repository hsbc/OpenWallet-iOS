//
//  ItemsModel.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/6.
//

import Foundation

struct ItemListModel: Hashable, Codable, Identifiable {
    var id: Int
    var title: String
    var isComingSoon: Bool
    var items: [ItemModel]
}
