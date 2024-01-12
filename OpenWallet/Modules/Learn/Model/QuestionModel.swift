//
//  QuestionModel.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/11.
//

import Foundation
import SwiftUI

struct QuestionModel: Hashable, Codable, Identifiable {
    var id: Int
    var type: String
    var category: String
    var question: String
    var choices: [String]
    var resourceLinks: [String]
}
