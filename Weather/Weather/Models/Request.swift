//
//  Request.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/17/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import Foundation
import SwiftyJSON

class Request {
    static func request(url: String, complete: @escaping (JSON)->Void) { //TO DO : check internet connection
        guard let url = URL(string: url) else {
            print("Error create Url")
            return
        }
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                guard let data = data else { return }
                complete(JSON(data))
            } else {
                print("error request , status code = \(httpResponse.statusCode) , url = \(url)")
            }
        }
        task.resume()
    }
}
