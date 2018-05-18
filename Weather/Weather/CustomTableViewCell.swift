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
        guard let maxTemp = data.temperatureMax, let minTemp = data.temperatureMin,
            let dayOfWeek = data.dayOfWeek else { return }
        self.dayOfWeek.text = dayOfWeek
        self.maxTemperature.text = "\(maxTemp)°"
        self.minTemperature.text = "\(minTemp)°"
    }
}
