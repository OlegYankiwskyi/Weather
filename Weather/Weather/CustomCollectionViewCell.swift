//
//  CollectionViewCell.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/15/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    func configure(data: WeatherHours) {
        if let time = data.time {
            self.time.text = "\(time)"
        }
        if let temperature = data.temperature {
            self.temperature.text = "\(temperature)°"
        }
    }
}
