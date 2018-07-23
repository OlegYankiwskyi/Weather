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
    static func request(url urlString: String, completion: @escaping (JSON, Error?)->Void) {
        guard let url = URL(string: urlString) else {
            completion(JSON.null, .createUrl)
            return
        }
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(JSON.null, .invalidData)
                return
            }
            if (200 ... 299).contains(httpResponse.statusCode) {
                guard let data = data else {
                    completion(JSON.null, .invalidData)
                    return
                }
                completion(JSON(data), nil)
            } else {
                completion(JSON.null, .statusCode(code: httpResponse.statusCode))
            }
        }
        task.resume()
    }
}


