//
//  UITableViewCell.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/17/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    class var reuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}
