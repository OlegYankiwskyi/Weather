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
    var currentController: WeatherCityController?
    var navBar: UINavigationBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        citiesModel.updateView = updateData
        
        createMenu()
        guard let controller = createWeatherCityController(index: 0) else { return }
        currentController = controller as? WeatherCityController
        setViewControllers([controller], direction: .forward, animated: true, completion: nil)
    }
    
    @objc func tapsOnAdd() {
        currentController?.add()
    }
    
    @objc func tapsOnDelete() {
        currentController?.delete()
    }
    
    func updateData(type: TypeOperation) {
        switch type {
        case .append:
            guard let city = self.citiesModel.cities.last else { return }
            self.models.append(WeatherModelFactory.getModel(type: city))
            guard let controller = createWeatherCityController(index: models.count-1) else { return }
            navBar?.isHidden = false
            setViewControllers([controller], direction: .forward, animated: true, completion: nil)
            
        case .delete(let index):
            self.models.remove(at: index)
            if let controller = createWeatherCityController(index: 0) {
                setViewControllers([controller], direction: .forward, animated: true, completion: nil)
            } else {
                setViewControllers([newCityController() ?? UIViewController()], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    
    private func newCityController() -> UIViewController? {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: AddNewCityController.reuseIdentifier) as? AddNewCityController else { return nil }
        controller.modelDelegate = citiesModel
        navBar?.isHidden = true
        return controller
    }
    
    private func createWeatherCityController(index: Int) -> UIViewController? {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: WeatherCityController.reuseIdentifier) as? WeatherCityController else { return nil }
        controller.modelDelegate = citiesModel
        
        if !models.indices.contains(0) {
            return newCityController()
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
                if city is WeatherLocationModel {
                    return i
                }
            }
        }
        return nil
    }
    
    private func createMenu() {
        let height = CGFloat(44)
        navBar = UINavigationBar(frame: CGRect(x: 0, y: view.frame.maxY - height, width: view.frame.maxX, height: height))
        self.view.addSubview(navBar!)
        let navItem = UINavigationItem(title: "")
        let doneItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector (tapsOnAdd))
        let deleteItem = UIBarButtonItem(barButtonSystemItem: .trash, target: nil, action: #selector (tapsOnDelete))
        navItem.leftBarButtonItem = doneItem
        navItem.rightBarButtonItem = deleteItem
        navBar!.setItems([navItem], animated: false)
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
        return createWeatherCityController(index: viewControllerIndex-1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? WeatherCityController,
            let viewControllerIndex = getIndex(city: controller.model)
               else { return nil }
        if viewControllerIndex+1 >= citiesModel.cities.count {
            return nil
        }
        return createWeatherCityController(index: viewControllerIndex+1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if (completed) {
            guard let controller = pageViewController.viewControllers!.first as? WeatherCityController else {
                currentController = nil
                return
            }
            currentController = controller
        }
        
    }
}

