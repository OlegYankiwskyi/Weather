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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("NewCityController")
    }
    
    
    @IBAction func tapButton(_ sender: Any) {
        print(cityTextField.text)
//        self.dismiss(animated: true)
    }
    
}
