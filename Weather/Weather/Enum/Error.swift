//
//  Error.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/31/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import Foundation

enum Error {
    case invalidData
    case locationKey
    case statusCode(code: Int)
    case createUrl
    
    var description: String {
        switch self {
        case .invalidData:
            return "Bad response`s data"
        case .locationKey:
            return "Location Key is invalid"
        case .statusCode(let code):
            return "Response code = \(code)"
        case .createUrl:
            return "Url is not valid"
        }
    }
}
