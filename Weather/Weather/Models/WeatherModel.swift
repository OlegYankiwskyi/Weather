//
//  WeatherModel.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/15/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import Foundation
import SwiftyJSON

class WeatherModel {
    
    let apiKey = "lLtDQNZwsQGX17TKr6d4T2Ymwwl5ZAFz"
    var weatherDay = WeatherDay()
    var weatherHours: [WeatherHours] = []
    
    func updateData(latitude: Double, longitude: Double, complete: @escaping ()->Void) {
        guard let url = URL(string: "https://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=\(apiKey)&q=\(latitude)%2C\(longitude)") else {
            print("Error create Url")
            return
        }
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            let locationKey = JSON(data)["Key"]
            if locationKey == "null" {
                print("locationKey is null")
                return
            }
            if let city = JSON(data)["AdministrativeArea"]["EnglishName"].string {
                self.weatherDay.city = city
            }
            self.getWeatherDay(locationKey: locationKey, complete: complete)
            self.getWeatherHours(locationKey: locationKey, complete: complete)
            
        }
        task.resume()
    }
    
    private func getWeatherDay(locationKey: JSON, complete: @escaping ()->Void) {
        let url = URL(string: "https://dataservice.accuweather.com/forecasts/v1/daily/1day/\(locationKey)?apikey=\(apiKey)&metric=true")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard let data = data else { return }
            
            self.weatherDay.temperatureMax = JSON(data)["DailyForecasts"][0]["Temperature"]["Maximum"]["Value"].int
            self.weatherDay.temperatureMin = JSON(data)["DailyForecasts"][0]["Temperature"]["Minimum"]["Value"].int
            self.weatherDay.dayDescription = JSON(data)["DailyForecasts"][0]["Day"]["IconPhrase"].string
            self.weatherDay.nightDescription = JSON(data)["DailyForecasts"][0]["Night"]["IconPhrase"].string
            complete()
        }
        task.resume()
    }
    
    private func getWeatherHours(locationKey: JSON, complete: @escaping ()->Void) {
        let url = URL(string: "https://dataservice.accuweather.com/forecasts/v1/hourly/12hour/\(locationKey)?apikey=\(apiKey)&metric=true")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            guard let data = data else { return }

            for i in 0..<12 {
                let temperature = JSON(data)[i]["Temperature"]["Value"]
                if self.weatherHours.indices.contains(i) {
                    self.weatherHours[i] = WeatherHours(temperature: temperature.int)
                } else {
                    self.weatherHours.append(WeatherHours(temperature: temperature.int))
                }
            }
            complete()
        }
        task.resume()
    }
}

struct WeatherDay {
    var city: String?
    var nightDescription: String?
    var dayDescription: String?
    var temperatureMax: Int?
    var temperatureMin: Int?
}

struct WeatherHours {
    var temperature: Int?
}



