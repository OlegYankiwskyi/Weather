//
//  CitiesModel.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/16/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import Foundation
import CoreLocation

class CitiesModel: Request {
    var cities: [TypeModel] = [] 
    var updateView: ((TypeOperation)->Void)?
    private let keyArray = "citiesArray"
    
    override init() {
        super.init()
        self.uploadData()
//        self.saveData()
    }
    
    func isValidCity(city: String, complete: @escaping (Bool,String)->Void) {
        var parcedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        parcedCity = parcedCity.replacingOccurrences(of: " ", with: "%20")
        let url = "https://dataservice.accuweather.com/locations/v1/cities/search?apikey=\(ApiKey.key)&q=\(parcedCity)"
        
        Request.request(url: url, complete: { data in
            if let city = data[0]["EnglishName"].string {
                complete(true, city)
            } else {
                complete(false, "")
            }
        })
    }
    
    func isValidCity(longitude: Double,latitude: Double, complete: @escaping (Bool,String)->Void) {
        let url = "https://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=\(ApiKey.key)&q=\(latitude)%2C\(longitude)"

        Request.request(url: url, complete: { data in
            if let city = data["ParentCity"]["EnglishName"].string {
                complete(true, city)
            } else if let city = data["EnglishName"].string {
                complete(true, city)
            } else {
                complete(false, "")
            }
        })
    }
    
    func deleteCity(city cityName: String) -> Bool {
        if cities.count <= 1 {
            return false
        } else if let index = cities.index(of: .city(name: cityName)) {
            cities.remove(at: index)
            updateView?(.delete(index: index))
            saveData()
            return true
        } 
        return false
    }
    
    func addCity(city cityName: String) -> Bool {
        let parcedCity = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        let isContains = cities.contains { $0 == .city(name: parcedCity) }
    
        if isContains {
            return false
        } else {
            cities.append(.city(name: parcedCity))
            updateView?(.append)
            self.saveData()
            return true
        }
    }
    
    private func saveData() {
        let defaults = UserDefaults.standard
        var array: [String] = []
        for i in 0..<cities.count {
            switch cities[i] {
            case .city(let name):
                array.append(name)
            default:
                break
            }
        }
        defaults.set(array, forKey: keyArray)
    }
    
    private func uploadData() {
        let defaults = UserDefaults.standard
        let myarray = defaults.stringArray(forKey: keyArray) ?? [String]()

        if Location.isEnabled() {
            cities = [.location]
        }
        for i in 0..<myarray.count {
            print(myarray[i])
            cities.append(.city(name: myarray[i]))
        }
        if cities.count == 0 {
            cities.append(.city(name: "London"))
        }
    }
}

