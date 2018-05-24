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
    static func request(url: String, complete: @escaping (JSON)->Void) {
        guard let url = URL(string: url) else {
            print("Error create Url")
            return
        }
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            if 200 ... 299 ~= httpResponse.statusCode {
                guard let data = data else { print("error"); return }
                complete(JSON(data))
            } else {
                print("error request , status code = \(httpResponse.statusCode) , url = \(url)")
            }
        }
        task.resume()
    }
}
//class Request {
//    static func request(url: String, complete: @escaping (JSON)->Void) {
//        guard let url = URL(string: url) else { print("Error create Url"); return }
//
//        Alamofire.request(url)
//            .validate(statusCode: 200..<300)
//            .validate(contentType: ["application/json"])
//            .responseData { response in
//                switch response.result {
//                case .success:
//                    guard let data = response.data else { print("error"); return }
//                    complete(JSON(data))
//                case .failure(let error):
//                    print("\(error.localizedDescription) , url = \(url)")
//                }
//        }
//    }
//}

