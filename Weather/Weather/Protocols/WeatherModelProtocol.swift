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
    var weatherTwelveHours: [WeatherHours] { get set }
    var weatherTenDays: [WeatherDay] { get set }
    var city: String { get set }

    func updateData(complete: @escaping ()->Void)
}

extension WeatherModelProtocol {
    func getWeatherOneDay(locationKey: JSON, complete: @escaping ()->Void) {
        let url = "https://dataservice.accuweather.com/forecasts/v1/daily/1day/\(locationKey)?apikey=\(ApiKey.key)&metric=true"
        Request.request(url: url, complete: { data in
            self.weatherDay.temperatureMax = data["DailyForecasts"][0]["Temperature"]["Maximum"]["Value"].int
            self.weatherDay.temperatureMin = data["DailyForecasts"][0]["Temperature"]["Minimum"]["Value"].int
            self.weatherDay.dayDescription = data["DailyForecasts"][0]["Day"]["IconPhrase"].string
            self.weatherDay.nightDescription = data["DailyForecasts"][0]["Night"]["IconPhrase"].string
            complete()
        })
    }
    
    func getWeatherTwelveHours(locationKey: JSON, complete: @escaping ()->Void) {
        let url = "https://dataservice.accuweather.com/forecasts/v1/hourly/12hour/\(locationKey)?apikey=\(ApiKey.key)&metric=true"
        Request.request(url: url, complete: { data in
            for i in 0..<12 {
                guard let temperature = data[i]["Temperature"]["Value"].int,
                    let time = data[i]["DateTime"].string else { return }
                self.weatherTwelveHours[i] = WeatherHours(temperature: temperature, time: Parser.getTime(str: time))
            }
            complete()
        })
    }
    
    func getWeatherFiveDays(locationKey: JSON, complete: @escaping ()->Void) {
        let url = "https://dataservice.accuweather.com/forecasts/v1/daily/5day/\(locationKey)?apikey=\(ApiKey.key)&metric=true"
        Request.request(url: url, complete: { data in
            for i in 0..<self.weatherTenDays.count {
                self.weatherTenDays[i].temperatureMax = data["DailyForecasts"][i]["Temperature"]["Maximum"]["Value"].int
                self.weatherTenDays[i].temperatureMin = data["DailyForecasts"][i]["Temperature"]["Minimum"]["Value"].int
                self.weatherTenDays[i].dayDescription = data["DailyForecasts"][i]["Day"]["IconPhrase"].string
                self.weatherTenDays[i].nightDescription = data["DailyForecasts"][i]["Night"]["IconPhrase"].string
                if let date = data["DailyForecasts"][i]["Date"].string {
                    self.weatherTenDays[i].dayOfWeek = Parser.getDayOfWeek(date)
                }
            }
            complete()
        })
    }
}
