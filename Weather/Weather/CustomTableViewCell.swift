//
//  CustomCell.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/17/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var maxTemperature: UILabel!
    @IBOutlet weak var minTemperature: UILabel!
    
    func configure(data: WeatherDay) {
        if let dayOfWeek = data.dayOfWeek {
            self.dayOfWeek.text = dayOfWeek
        }
        if let maxTemp = data.temperatureMax {
            self.maxTemperature.text = "\(maxTemp)°"
        }
        if let minTemp = data.temperatureMin {
            self.minTemperature.text = "\(minTemp)°"
        }
    }
}
