//
//  Date.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/20/22.
//

import Foundation

extension Date {
    var toNotificationPostedDateFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let formattedDate = dateFormatter.string(from: self)
        return formattedDate
    }
    
    var toMonthDayYearFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let formattedDate = dateFormatter.string(from: self)
        return formattedDate
    }
    
    var toTimeOfDay: String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        return Date.hourToTimeOfDay(hour)
    }
    
    static func hourToTimeOfDay(_ hour: Int) -> String {
        switch hour {
        case 5..<12:
            return DayOfTime.morning.rawValue
        case 12..<17:
            return DayOfTime.afternoon.rawValue
        case 17..<21:
            return DayOfTime.evening.rawValue
        default:
            return DayOfTime.night.rawValue
        }
    }
}
