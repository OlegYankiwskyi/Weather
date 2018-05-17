//
//  WeatherModelProtocol.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/16/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol WeatherModelProtocol: class {
    var weatherDay: WeatherDay { get set }
    var weatherHours: [WeatherHours] { get set }

    func updateData(complete: @escaping ()->Void)
}


extension WeatherModelProtocol {
    var apiKey: String {
        get { return "KvvMYvZVE3npBaeQRImyfRFAnallK4Qp" }
    }
    
    func getWeatherDay(locationKey: JSON, complete: @escaping ()->Void) {
        let url = "https://dataservice.accuweather.com/forecasts/v1/daily/1day/\(locationKey)?apikey=\(apiKey)&metric=true"
        request(url: url, complete: { data in
            self.weatherDay.temperatureMax = data["DailyForecasts"][0]["Temperature"]["Maximum"]["Value"].int
            self.weatherDay.temperatureMin = data["DailyForecasts"][0]["Temperature"]["Minimum"]["Value"].int
            self.weatherDay.dayDescription = data["DailyForecasts"][0]["Day"]["IconPhrase"].string
            self.weatherDay.nightDescription = data["DailyForecasts"][0]["Night"]["IconPhrase"].string
            complete()
        })
    }
    
    func getWeatherHours(locationKey: JSON, complete: @escaping ()->Void) {
        let url = "https://dataservice.accuweather.com/forecasts/v1/hourly/12hour/\(locationKey)?apikey=\(apiKey)&metric=true"
        request(url: url, complete: { data in
            for i in 0..<12 {
                let temperature = data[i]["Temperature"]["Value"]
                if self.weatherHours.indices.contains(i) {
                    self.weatherHours[i] = WeatherHours(temperature: temperature.int)
                } else {
                    self.weatherHours.append(WeatherHours(temperature: temperature.int))
                }
            }
            complete()
        })
    }
    
    func request(url: String, complete: @escaping (JSON)->Void) {
        guard let url = URL(string: url) else {
            print("Error create Url")
            return
        }
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            complete(JSON(data))
        }
        task.resume()
    }
}
