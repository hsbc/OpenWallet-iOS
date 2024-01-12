//
//  GetQuizResponse.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/13.
//

import Foundation

struct GetQuizResponse: Decodable {
    let quizLists: [QuizModel]
}
