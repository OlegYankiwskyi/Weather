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
    @IBOutlet weak var weatherHours: UICollectionView!
    @IBOutlet weak var temperatureMaxLabel: UILabel!
    @IBOutlet weak var temperatureMinLabel: UILabel!
    @IBOutlet weak var dayWeatherLabel: UILabel!
    @IBOutlet weak var nightWeatherLabel: UILabel!
    
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
            self.cityLabel.text = self.model.weatherDay.city
            self.temperatureMaxLabel.text = "Max = \(maxTemp)° C"
            self.temperatureMinLabel.text = "Min = \(minTemp)° C"
            self.dayWeatherLabel.text = "day: \(dayWeather)"
            self.nightWeatherLabel.text = "night: \(nightWeather)"
            self.weatherHours.reloadData()
        }
    }
    
    @IBAction func addCityTap(_ sender: Any) {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewCityController") as? NewCityController else { return }
        self.present(controller, animated: true, completion: nil)
    }
}

extension WeatherCityController: UICollectionViewDelegate, UICollectionViewDataSource {
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



