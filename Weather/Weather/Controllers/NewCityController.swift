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
        citiesModel.isValidCity(city: cityTextField.text!, complete: { isValid in
            DispatchQueue.main.async {
                if isValid {
                    self.cityTextField.backgroundColor = .green
                    self.dismiss(animated: true)
                } else {
                    self.cityTextField.backgroundColor = .red
                }
            }
        })
    }
}
