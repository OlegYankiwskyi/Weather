//
//  NewCityController.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/16/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import UIKit

class NewCityController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    let citiesModel = CitiesModel()
    
    @IBAction func edit(_ sender: Any) {
        self.cityTextField.backgroundColor = .clear
    }
    
    @IBAction func tapButton(_ sender: Any) {
        guard let city = cityTextField.text else {
            self.cityTextField.backgroundColor = .red
            return
        }
        citiesModel.isValidCity(city: city, complete: { isValid, cityName in
            DispatchQueue.main.async {
                if isValid {
                    self.cityTextField.backgroundColor = .green
                    self.citiesModel.addCity(city: cityName)
                    self.dismiss(animated: true)
                } else {
                    self.cityTextField.backgroundColor = .red
                }
            }
        })
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension NewCityController: UITextFieldDelegate {
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
