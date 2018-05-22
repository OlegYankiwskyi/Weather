//
//  WeatherHour.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/16/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import Foundation

struct WeatherHours {
    var temperature: Int?
    var time: String?
    var isLoad = false
    
    init() {}

    init(temperature: Int?, time: String?) {
        self.temperature = temperature
        self.time = time
    }
}
