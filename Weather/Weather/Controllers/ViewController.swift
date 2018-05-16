//
//  ViewController.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/15/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    let locationManager = CLLocationManager()
    let model = WeatherModel()
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherHours: UICollectionView!
    @IBOutlet weak var temperatureMaxLabel: UILabel!
    @IBOutlet weak var temperatureMinLabel: UILabel!
    @IBOutlet weak var dayWeatherLabel: UILabel!
    @IBOutlet weak var nightWeatherLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startReceivingLocationChanges()
    }

    private func startReceivingLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            return
        }
        if !CLLocationManager.locationServicesEnabled() {
            return
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = 3000.0  // In meters.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    private func updateInterface() {
        guard let maxTemp = model.weatherDay.temperatureMax, let minTemp = model.weatherDay.temperatureMin,
         let nightWeather = model.weatherDay.nightDescription, let dayWeather = model.weatherDay.dayDescription else { return }
        cityLabel.text = model.weatherDay.city
        temperatureMaxLabel.text = "Max = \(maxTemp)° C"
        temperatureMinLabel.text = "Min = \(minTemp)° C"
        dayWeatherLabel.text = "day: \(dayWeather)"
        nightWeatherLabel.text = "night: \(nightWeather)"
        weatherHours.reloadData()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.weatherHours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.reuseIdentifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        if let temperature = model.weatherHours[indexPath.row].temperature {
            cell.label.text = "\(temperature)° C"
        } else {
            cell.label.text = "good"
        }
        return cell
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
        print("update \(lastLocation.coordinate)")
        model.updateData(latitude: lastLocation.coordinate.latitude, longitude:lastLocation.coordinate.longitude) {
            DispatchQueue.main.sync {
                self.updateInterface()
            }
        }
    }
}

