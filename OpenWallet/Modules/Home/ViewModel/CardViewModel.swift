//
//  CardViewModel.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/6.
//

import Foundation

class CardViewModel: ObservableObject {
    @Published var itemLists: [ItemListModel] = JsonLoader.load("ItemsData.json")
    @Published var projectsLists: [ItemListModel] = JsonLoader.load("ProjectsData.json")
    @Published var showAlert: Bool = false
}
