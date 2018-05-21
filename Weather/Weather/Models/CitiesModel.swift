//
//  CitiesModel.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/16/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import Foundation

class CitiesModel: Request {
    private var arrayCities: [TypeModel] = [.location]
    var cities: [TypeModel] {
        get {
            self.updateData()
            return arrayCities
        }
    }
    private let keyArray = "citiesArray"
    
    override init() {
        super.init()
        self.updateData()
    }
    
    func isValidCity(city: String, complete: @escaping (Bool,String)->Void) {
        let parcedCity = city.replacingOccurrences(of: " ", with: "%20")
        let url = "https://dataservice.accuweather.com/locations/v1/cities/search?apikey=\(ApiKey.key)&q=\(parcedCity)"
        
        Request.request(url: url, complete: { data in
            if let city = data[0]["EnglishName"].string {
                complete(true, city)
            } else {
                complete(false, "")
            }
        })
    }
    
    func deleteCity(city cityName: String) {
        if let index = cities.index(of: .city(name: cityName)) {
            arrayCities.remove(at: index)
            saveData()
        }
    }
    
    func addCity(city cityName: String) {
        let isContains = arrayCities.contains { $0 == .city(name: cityName) }
    
        if isContains {
            return
        } else {
            arrayCities.append(.city(name: cityName))
            self.saveData()
        }
    }
    
    private func saveData() {
        let defaults = UserDefaults.standard
        var array: [String] = []
        for i in 1..<arrayCities.count {
            switch arrayCities[i] {
            case .city(let name):
                array.append(name)
            default:
                print("bad value")
            }
        }
        defaults.set(array, forKey: keyArray)
    }
    
    private func updateData() {
        let defaults = UserDefaults.standard
        let myarray = defaults.stringArray(forKey: keyArray) ?? [String]()
        arrayCities = [.location]
        for i in 0..<myarray.count {
            arrayCities.append(.city(name: myarray[i]))
        }
    }
}

