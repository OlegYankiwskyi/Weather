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
    var weatherDay: WeatherDay? { get set }
    var weatherTwelveHours: [WeatherHours] { get set }
    var weatherFiveDays: [WeatherDay] { get set }
    var city: String! { get set }

    func updateData(completion: @escaping (Error?)->Void)
}

extension WeatherModelProtocol {
    var isLoaded: Bool {
        get {
            if weatherDay == nil {
                return false
            }
            for i in 0..<weatherTwelveHours.count {
                if !weatherTwelveHours[i].isLoaded {
                    return false
                }
            }
            for i in 0..<weatherFiveDays.count {
                if !weatherFiveDays[i].isLoaded {
                    return false
                }
            }
            return true
        }
    }
    func getWeatherOneDay(locationKey: JSON, completion: ((Error?)->Void)?) {
        let url = "https://dataservice.accuweather.com/forecasts/v1/daily/1day/\(locationKey)?apikey=\(ApiKey.key)&metric=true"
        Request.request(url: url, completion: { data, error in
            if let error = error {
                completion?(error)
                return
            }
            self.weatherDay = self.weatherDay ?? WeatherDay()
            self.weatherDay?.temperatureMax = data["DailyForecasts"][0]["Temperature"]["Maximum"]["Value"].int
            self.weatherDay?.temperatureMin = data["DailyForecasts"][0]["Temperature"]["Minimum"]["Value"].int
            self.weatherDay?.dayDescription = data["DailyForecasts"][0]["Day"]["IconPhrase"].string
            self.weatherDay?.nightDescription = data["DailyForecasts"][0]["Night"]["IconPhrase"].string
            self.weatherDay?.isLoaded = true
            completion?(nil)
        })
    }
    
    func getWeatherTwelveHours(locationKey: JSON, completion: ((Error?)->Void)?) {
        let url = "https://dataservice.accuweather.com/forecasts/v1/hourly/12hour/\(locationKey)?apikey=\(ApiKey.key)&metric=true"
        Request.request(url: url, completion: { data, error in
            if let error = error {
                completion?(error)
                return
            }
            for i in 0..<12 {
                guard let temperature = data[i]["Temperature"]["Value"].int,
                    let time = data[i]["DateTime"].string else { return }
                self.weatherTwelveHours[i] = WeatherHours(temperature: temperature, time: Parser.getTime(str: time))
                self.weatherTwelveHours[i].isLoaded = true
            }
            completion?(nil)
        })
    }
    
    func getWeatherFiveDays(locationKey: JSON, completion: ((Error?)->Void)?) {
        let url = "https://dataservice.accuweather.com/forecasts/v1/daily/5day/\(locationKey)?apikey=\(ApiKey.key)&metric=true"
        Request.request(url: url, completion: { data, error in
            if let error = error {
                completion?(error)
                return
            }
            for i in 0..<self.weatherFiveDays.count {
                self.weatherFiveDays[i].temperatureMax = data["DailyForecasts"][i]["Temperature"]["Maximum"]["Value"].int
                self.weatherFiveDays[i].temperatureMin = data["DailyForecasts"][i]["Temperature"]["Minimum"]["Value"].int
                self.weatherFiveDays[i].dayDescription = data["DailyForecasts"][i]["Day"]["IconPhrase"].string
                self.weatherFiveDays[i].nightDescription = data["DailyForecasts"][i]["Night"]["IconPhrase"].string
                if let date = data["DailyForecasts"][i]["Date"].string {
                    self.weatherFiveDays[i].dayOfWeek = Parser.getDayOfWeek(date)
                }
                self.weatherFiveDays[i].isLoaded = true
            }
            completion?(nil)
        })
    }
}
