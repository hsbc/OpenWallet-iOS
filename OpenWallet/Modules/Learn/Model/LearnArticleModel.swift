//
//  LearnArticleModel.swift
//  OpenWalletStaff
//
//  Created by LuoYao on 2022/9/18.
//

import Foundation
import SwiftUI

struct LearnArticleModel: Hashable, Codable, Identifiable {
    var id: Int
    var subTitle: String
    var title: String
    var subjects: [SubjectModel]
    var bannerImageLink: String
    var headerImageLink: String
}

struct SubjectModel: Hashable, Codable, Identifiable {
    var id: Int
    var imageLinks: [String]
    var subTitle: String
    var paragraphs: [ParagraphModel]
}

struct ParagraphModel: Hashable, Codable, Identifiable {
    var id: Int
    var paragraphTitle: String
    var content: String
    var imageLinks: [String]
}
