//
//  ActivityModel.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/15.
//

import Foundation
import SwiftUI

struct ActivityModel: Decodable {
    var currentTime: String
    var activityId: Int
    var activityName: String
    var activityDescription: String
    var rewardType: String
    
    var smartContractAddress: String
    var rewardAmount: Int
    var createdBy: String
    var createdTime: String
    
    var lastModifiedBy: String?
    var lastModifiedTime: String?
    var totalIssuedRewardAmount: Int
    var activityStatus: String

}
