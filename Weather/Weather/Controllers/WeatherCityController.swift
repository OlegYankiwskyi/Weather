//
//  ViewController.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/15/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD

class WeatherCityController: UIViewController {
    var model: WeatherModelProtocol!
    var modelDelegate: CitiesModel!
    var hud: MBProgressHUD!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherTwelveHours: UICollectionView!
    @IBOutlet weak var temperatureMaxLabel: UILabel!
    @IBOutlet weak var temperatureMinLabel: UILabel!
    @IBOutlet weak var dayWeatherLabel: UILabel!
    @IBOutlet weak var nightWeatherLabel: UILabel!
    @IBOutlet weak var weatherFiveDays: UITableView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        
        navigationBar.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: nil, action: #selector(deleteCity))
        navigationBar.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(addCity))
        navigationBar.rightBarButtonItem?.isEnabled = false
        model.updateData {
            self.updateInterface()
        }
    }
    
    func updateInterface() {
        DispatchQueue.main.async {
            self.cityLabel.text = self.model.city
            if let maxTemp = self.model.weatherDay?.temperatureMax {
                self.temperatureMaxLabel.text = "Max = \(maxTemp)° C"
            }
            if let minTemp = self.model.weatherDay?.temperatureMin {
                self.temperatureMinLabel.text = "Min = \(minTemp)° C"
            }
            if let nightWeather = self.model.weatherDay?.nightDescription {
                self.nightWeatherLabel.text = "night: \(nightWeather)"
            }
            if let dayWeather = self.model.weatherDay?.dayDescription {
                self.dayWeatherLabel.text = "day: \(dayWeather)"
            }
            self.weatherTwelveHours.reloadData()
            self.weatherFiveDays.reloadData()
            self.hud.hide(animated: true, afterDelay: 0.1)
        }
    }
    
    @objc func addCity() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewCityController") as? NewCityController else { return }
        controller.modelDelegate = modelDelegate
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func deleteCity() {
        modelDelegate.deleteCity(city: model.city)
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
        return model.weatherFiveDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseIdentifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        cell.configure(data: model.weatherFiveDays[indexPath.row])
        return cell
    }
}



