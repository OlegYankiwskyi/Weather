//
//  WeatherModelFactory.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/16/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import Foundation

class WeatherModelFactory {
    static func getModel(type: TypeModel) -> WeatherModelProtocol {
        switch type {
        case .location:
            return WeatherLocationModel()
        case .city(let city):
            return WeatherCityModel(city: city)
        }
    }
}
