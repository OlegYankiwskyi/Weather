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
            if controllersStore.count == citiesModel.cities.count {
                return controllersStore
            } else if controllersStore.count+1 == citiesModel.cities.count {
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherCityController") as! WeatherCityController
                controller.model = WeatherModelFactory.getModel(type: citiesModel.cities.last!)
                controllersStore.append(controller)
                return controllersStore
            } else {
                return controllersStore
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<citiesModel.cities.count {//TO DO
            guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: WeatherCityController.reuseIdentifier) as? WeatherCityController else { return }
            controller.model = WeatherModelFactory.getModel(type: citiesModel.cities[i])
            controllersStore.append(controller)
        }
        self.delegate = self
        self.dataSource = self
        setViewControllers([controllers[0]], direction: .forward, animated: true, completion: nil)
    }
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource  {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = controllers.index(of: viewController as! WeatherCityController) else {
            return nil
        }
        if viewControllerIndex-1 < 0  {
            return nil
        }
        return controllers[viewControllerIndex-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = controllers.index(of: viewController as! WeatherCityController) else {
            return nil
        }
        if viewControllerIndex+1 >= controllers.count {
            return nil
        }
        return controllers[viewControllerIndex+1]
    }
}
