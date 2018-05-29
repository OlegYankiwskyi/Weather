//
//  Request.swift
//  Weather
//
//  Created by Oleg Yankiwskyi on 5/17/18.
//  Copyright © 2018 Oleg Yankiwskyi. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Request {
    static func request(url: String, complete: @escaping (JSON)->Void) {
        guard let url = URL(string: url) else { print("Error create Url"); return }
        
        Alamofire.request(url)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    guard let data = response.data else { print("error"); return }
                    complete(JSON(data))
                case .failure(let error):
                    print("\(error.localizedDescription) , url = \(url)")
                }
        }
    }
}


