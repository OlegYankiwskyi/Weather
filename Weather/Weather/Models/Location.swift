//
//  Location.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/22/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    static func isEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            }
        } else {
            return false
        }
    }
}
