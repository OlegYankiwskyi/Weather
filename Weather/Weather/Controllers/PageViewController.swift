//
//  PageViewController.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/16/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var citiesModel = CitiesModel()
    var controllersStore: [WeatherCityController] = []
    
    var controllers: [WeatherCityController] {
        get {
            let controllersCount = controllersStore.count
            let citiesCount = citiesModel.cities.count
            
            if controllersCount == citiesCount {
                return controllersStore
            } else if controllersCount+1 == citiesCount {
                guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: WeatherCityController.reuseIdentifier) as? WeatherCityController else { return controllersStore }
                controller.model = WeatherModelFactory.getModel(type: citiesModel.cities.last!)
                controller.modelDelegate = citiesModel
                controllersStore.append(controller)
                return controllersStore
            } else {
                updateControllers()
                return controllersStore
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateControllers()
        self.delegate = self
        self.dataSource = self
    }
    
    private func updateControllers() {
        controllersStore = []
        for i in 0..<citiesModel.cities.count {
            
            guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: WeatherCityController.reuseIdentifier) as? WeatherCityController else { break }
            controller.model = WeatherModelFactory.getModel(type: citiesModel.cities[i])
            controller.modelDelegate = citiesModel
            controllersStore.append(controller)
        }
        setViewControllers([controllers[0]], direction: .forward, animated: true, completion: nil)
    }
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource  {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? WeatherCityController, let viewControllerIndex = controllers.index(of: controller) else {
            return nil
        }
        if viewControllerIndex-1 < 0  {
            return nil
        }
        return controllers[viewControllerIndex-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? WeatherCityController, let viewControllerIndex = controllers.index(of: controller) else {
            return nil
        }
        if viewControllerIndex+1 >= controllers.count {
            return nil
        }
        return controllers[viewControllerIndex+1]
    }
}
