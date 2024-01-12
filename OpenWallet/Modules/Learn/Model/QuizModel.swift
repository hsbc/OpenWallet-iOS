//
//  QuizModel.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/11.
//

import Foundation
import SwiftUI

struct QuizModel: Hashable, Codable, Identifiable {
    var id: Int
    
    var imageLinks: [String]
//    var image: Image {
//        Image(imageLinks[0])
//    }

    var description: String
    
    var subject: String
    
    var participationStatus: String?
}
