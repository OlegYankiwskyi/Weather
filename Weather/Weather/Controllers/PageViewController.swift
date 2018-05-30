//
//  PageViewController.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/16/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    let citiesModel = CitiesModel()
    lazy var models = [WeatherModelProtocol?](repeating: nil, count: citiesModel.cities.count)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        citiesModel.updateView = updateData
        
        guard let controller = createController(index: 0) else { return }
        setViewControllers([controller], direction: .forward, animated: true, completion: nil)
    }
    
    func updateData(type: TypeOperation) {
        switch type {
        case .append:
            guard let city = self.citiesModel.cities.last else { return }
            self.models.append(WeatherModelFactory.getModel(type: city))
            guard let controller = createController(index: models.count-1) else { return }
            setViewControllers([controller], direction: .forward, animated: true, completion: nil)
            
        case .delete(let index):
            self.models.remove(at: index)
            if let controller = createController(index: 0) {
                setViewControllers([controller], direction: .forward, animated: true, completion: nil)
            } else {
                guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: MapController.reuseIdentifier) as? MapController else { return }
                controller.modelDelegate = citiesModel
                setViewControllers([controller], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    
    private func createController(index: Int) -> UIViewController? {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: WeatherCityController.reuseIdentifier) as? WeatherCityController else { return nil }
        controller.modelDelegate = citiesModel
        if !models.indices.contains(0) {
            guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: MapController.reuseIdentifier) as? MapController else { return nil }
            controller.modelDelegate = citiesModel
            return controller
        } else if models[index] != nil {
            controller.model = models[index]
        } else {
            models[index] = WeatherModelFactory.getModel(type: citiesModel.cities[index])
            controller.model = models[index]
        }
        return controller
    }
    
    private func getIndex(city: WeatherModelProtocol) -> Int? {
        for i in 0..<citiesModel.cities.count {
            switch citiesModel.cities[i] {
            case .city(let name):
                if name == city.city {
                    return i
                }
            case .location:
                if city as? WeatherLocationModel != nil {
                    return i
                }
            }
        }
        return nil
    }
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? WeatherCityController,
            let viewControllerIndex = getIndex(city: controller.model)
              else { return nil }
        if viewControllerIndex-1 < 0  {
            return nil
        }
        return createController(index: viewControllerIndex-1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? WeatherCityController,
            let viewControllerIndex = getIndex(city: controller.model)
               else { return nil }
        if viewControllerIndex+1 >= citiesModel.cities.count {
            return nil
        }
        return createController(index: viewControllerIndex+1)
    }
}

