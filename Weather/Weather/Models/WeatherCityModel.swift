//
//  WeatherModel.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/15/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import Foundation
import SwiftyJSON

class WeatherCityModel: WeatherModelProtocol {

    var weatherDay = WeatherDay()
    var weatherHours: [WeatherHours] = []
    
    init(city: String) {
        self.weatherDay.city = city
    }
    
    func updateData(complete: @escaping ()->Void) {
        guard let city = self.weatherDay.city else { return }
        getLocationKey(city: city, complete: { locationKey in
            self.getWeatherDay(locationKey: locationKey, complete: complete)
            self.getWeatherHours(locationKey: locationKey, complete: complete)
        })
    }
    
    private func getLocationKey(city: String, complete: @escaping (JSON)->Void) {
        let parcedCity = city.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)//.replacingOccurrences(of: "  ", with: " ", options: .literal, range: nil)

        let url = "https://dataservice.accuweather.com/locations/v1/cities/search?apikey=\(apiKey)&q=\(parcedCity)"
        request(url: url, complete: { data in
            let locationKey = data[0]["Key"]
            if locationKey == "null" {
                print("locationKey is null")
                return
            }
            if let city = data[0]["EnglishName"].string {
                self.weatherDay.city = city
            }
            complete(locationKey)
        })
    }
}





