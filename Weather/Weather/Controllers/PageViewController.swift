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
    lazy var controllers: [WeatherCityController] = {
        var array: [WeatherCityController] = []
        
        citiesModel.cities.forEach({ type in
            guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherCityController") as? WeatherCityController else { return }
            controller.model = WeatherModelFactory.getModel(type: type)
            array.append(controller)
        })
        return array
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
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
