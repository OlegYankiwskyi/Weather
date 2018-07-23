//
//  ParseModel.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/17/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import Foundation

class Parser {
    static func getTime(str: String) -> String {
        return str[11 ..< 13]
    }
    
    static func getDayOfWeek(_ date: String) -> String {
        let parcedDate = date.substringToIndex(10)
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: parcedDate) else { return "nothing" }
        formatter.dateFormat = "EEEE"
        return formatter.string(from: todayDate).capitalized
    }
}



