//
//  WeatherLocationModel.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/16/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import Foundation
import SwiftyJSON
import MapKit

class WeatherLocationModel: NSObject, WeatherModelProtocol {
    var weatherDay: WeatherDay?
    var weatherTwelveHours = [WeatherHours](repeating: WeatherHours(), count: 12)
    var weatherFiveDays = [WeatherDay](repeating: WeatherDay(), count: 5)
    var city: String!
    lazy var locationManager = CLLocationManager()
    var callback: (()->Void)?
    
    func updateData(completion: @escaping ()->Void) {
        callback = completion
        updateLocation()
    }
    
    private func getLocationKey(latitude: Double, longitude: Double, complete: @escaping (JSON)->Void) {
        let url = "https://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=\(ApiKey.key)&q=\(latitude)%2C\(longitude)"
        Request.request(url: url, complete: { data in
            let locationKey = data["Key"]
            if locationKey == "null" {
                print("locationKey is null")
                return
            }
            if let city = data["ParentCity"]["EnglishName"].string {
                self.city = city
            } else if let city = data["AdministrativeArea"]["EnglishName"].string {
                self.city = city
            }
            complete(locationKey)
        })
    }

    private func updateLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100.0
        
        if Location.isEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            print("Location Services not endabled")
        }
    }
}

extension WeatherLocationModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        let latitude = lastLocation.coordinate.latitude
        let longitude = lastLocation.coordinate.longitude

        getLocationKey(latitude: latitude, longitude: longitude, complete: { locationKey in
            self.getWeatherOneDay(locationKey: locationKey, completion: self.callback)
            self.getWeatherTwelveHours(locationKey: locationKey, completion: self.callback)
            self.getWeatherFiveDays(locationKey: locationKey, completion: self.callback)
        })
    }
}

