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
    var weatherDay: WeatherDay?
    var weatherTwelveHours = [WeatherHours](repeating: WeatherHours(), count: 12)
    var weatherFiveDays = [WeatherDay](repeating: WeatherDay(), count: 5)
    var city: String!
    
    init(city: String) {
        self.city = city
    }
    
    func updateData(completion: @escaping (Error?)->Void) {
        getLocationKey(city: city, completion: { locationKey, error in
            if let error = error {
                completion(error)
                return
            }
            self.getWeatherOneDay(locationKey: locationKey, completion: completion)
            self.getWeatherTwelveHours(locationKey: locationKey, completion: completion)
            self.getWeatherFiveDays(locationKey: locationKey, completion: completion)
        })
    }
    
    private func getLocationKey(city: String, completion: @escaping (JSON, Error?)->Void) {
        var parcedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        parcedCity = parcedCity.replacingOccurrences(of: " ", with: "%20")

        let url = "https://dataservice.accuweather.com/locations/v1/cities/search?apikey=\(ApiKey.key)&q=\(parcedCity)"
        Request.request(url: url, completion: { data, error in
            if let error = error {
                completion(data, error)
                return
            }
            let locationKey = data[0]["Key"]
            if locationKey == "null" {
                print("locationKey is null")
                completion(locationKey, .locationKey)
                return
            }
            if let city = data[0]["EnglishName"].string {
                self.city = city
            }
            completion(locationKey, nil)
        })
    }
}





