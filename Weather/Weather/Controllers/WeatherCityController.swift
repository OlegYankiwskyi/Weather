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
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherTwelveHours: UICollectionView!
    @IBOutlet weak var temperatureMaxLabel: UILabel!
    @IBOutlet weak var temperatureMinLabel: UILabel!
    @IBOutlet weak var dayWeatherLabel: UILabel!
    @IBOutlet weak var nightWeatherLabel: UILabel!
    @IBOutlet weak var weatherFiveDays: UITableView!
    @IBOutlet weak var scrollRefresh: UIScrollView!
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    var model: WeatherModelProtocol!
    var modelDelegate: CitiesModel!
    var hud: MBProgressHUD?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollRefresh.addSubview(self.refreshControl)
        if model.isLoaded {
            updateInterface()
        } else if Reachability.isConnectedToNetwork() {
            setSubviewsHidden(true)
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud?.mode = .indeterminate
            hud?.detailsLabel.text = "Please wait"
            model.updateData {
                self.updateInterface()
            }
        } else {
            self.showAlert(title: "error", message: "Internet connection")
        }
    }
    
    private func setSubviewsHidden(_ hidden: Bool) {
        view.subviews.forEach { $0.isHidden = hidden }
    }
    
    func delete() {
        modelDelegate.deleteCity(city: model.city)
    }
    
    func add() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NewCityController.reuseIdentifier) as? NewCityController else { return }
        controller.modelDelegate = modelDelegate
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        if Reachability.isConnectedToNetwork() {
            model.updateData {
                self.updateInterface()
                refreshControl.endRefreshing()
            }
        } else {
            self.showAlert(title: "error", message: "Internet connection")
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
            
            if self.model.isLoaded {
                self.hud?.hide(animated: true, afterDelay: 0.1)
                self.setSubviewsHidden(false)
            }
        }
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
