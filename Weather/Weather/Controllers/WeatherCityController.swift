//
//  ViewController.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/15/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherCityController: UIViewController {
    var model: WeatherModelProtocol!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherTwelveHours: UICollectionView!
    @IBOutlet weak var temperatureMaxLabel: UILabel!
    @IBOutlet weak var temperatureMinLabel: UILabel!
    @IBOutlet weak var dayWeatherLabel: UILabel!
    @IBOutlet weak var nightWeatherLabel: UILabel!
    @IBOutlet weak var weatherFiveDays: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.updateData {
            self.updateInterface()
        }
    }

    func updateInterface() {
        DispatchQueue.main.async {
            guard let maxTemp = self.model.weatherDay.temperatureMax, let minTemp = self.model.weatherDay.temperatureMin,
                let nightWeather = self.model.weatherDay.nightDescription, let dayWeather = self.model.weatherDay.dayDescription else { return }
            self.cityLabel.text = self.model.city
            self.temperatureMaxLabel.text = "Max = \(maxTemp)° C"
            self.temperatureMinLabel.text = "Min = \(minTemp)° C"
            self.dayWeatherLabel.text = "day: \(dayWeather)"
            self.nightWeatherLabel.text = "night: \(nightWeather)"
            self.weatherTwelveHours.reloadData()
            self.weatherFiveDays.reloadData()
        }
    }
    
    @IBAction func addCityTap(_ sender: Any) {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewCityController") as? NewCityController else { return }
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func deleteCityTap(_ sender: Any) {
        let citiesModel = CitiesModel()
        citiesModel.deleteCity(city: model.city)

    }
    
}

extension WeatherCityController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.weatherTwelveHours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.reuseIdentifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(data: model.weatherTwelveHours[indexPath.row])

        return cell
    }
}

extension WeatherCityController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.weatherTenDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseIdentifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        cell.configure(data: model.weatherTenDays[indexPath.row])
        return cell
    }
}



