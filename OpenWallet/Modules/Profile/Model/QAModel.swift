//
//  QuestionModel.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/20.
//

import Foundation

struct QAModel: Decodable, Hashable {
    var id: Int
    var question: String
    var answer: String
    var category: String
}
