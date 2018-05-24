//
//  TypeModel.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/16/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import Foundation

enum TypeModel {
    case location
    case city(name: String)
}

extension TypeModel: Equatable {
    static func ==(lhs: TypeModel, rhs: TypeModel) -> Bool {
        
        switch (lhs, rhs) {
        case (city(let lhsName), city(let rhsName)):
            return lhsName == rhsName
        default:
            return false
        }
    }
}

