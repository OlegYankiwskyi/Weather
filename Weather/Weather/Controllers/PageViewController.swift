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
    let toolBar = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        citiesModel.updateView = updateData
        
        createMenu()
        guard let controller = createController(index: 0) else { return }
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
            guard let controller = createController(index: models.count-1) else { return }
            toolBar.isHidden = false
            setViewControllers([controller], direction: .forward, animated: true, completion: nil)
            
        case .delete(let index):
            self.models.remove(at: index)
            if let controller = createController(index: 0) {
                setViewControllers([controller], direction: .forward, animated: true, completion: nil)
            } else {
                guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NewCityController.reuseIdentifier) as? NewCityController else { return }
                controller.modelDelegate = citiesModel
                toolBar.isHidden = true
                setViewControllers([controller], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    
    private func createController(index: Int) -> UIViewController? {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: WeatherCityController.reuseIdentifier) as? WeatherCityController else { return nil }
        controller.modelDelegate = citiesModel
        
        if !models.indices.contains(0) {
            guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NewCityController.reuseIdentifier) as? NewCityController else { return nil }
            controller.modelDelegate = citiesModel
            toolBar.isHidden = true
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
    
    private func createMenu() {
        var items = [UIBarButtonItem]()
        items.append(
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapsOnAdd))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(tapsOnDelete))
        )
        
        toolBar.setItems(items, animated: true)
        view.addSubview(toolBar)
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        
        if #available(iOS 11.0, *) {
            let guide = self.view.safeAreaLayoutGuide
            toolBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            toolBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            toolBar.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
            toolBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        } else {
            NSLayoutConstraint(item: toolBar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: toolBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: toolBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true

            toolBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
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

