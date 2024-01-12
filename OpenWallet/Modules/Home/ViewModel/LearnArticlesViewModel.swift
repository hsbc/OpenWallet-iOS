//
//  LearnArticlesViewModel.swift
//  OpenWalletStaff
//
//  Created by LuoYao on 2022/9/18.
//

import Foundation
class LearnArticlesViewModel: ObservableObject {
    @Published var articlesList: [LearnArticleModel] = JsonLoader.load("LearnArticlesData.json")
    @Published var showAlert: Bool = false
}
