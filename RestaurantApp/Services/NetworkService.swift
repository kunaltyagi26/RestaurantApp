//
//  NetworkService.swift
//  RestaurantApp
//
//  Created by Kunal Tyagi on 10/02/19.
//  Copyright © 2019 Kunal Tyagi. All rights reserved.
//

import Foundation
import  Moya

private let apiKey = "C9AzPyhRrBuEiRAPziSi606uzNFnbF2fcFcGzx_JEvc8giWeFn5BSgTesMRKXv_KiSLu3EBjWncurvVHxOMjrArwl6UxiDhmWgR7ICGmsEhw8d1do2xhIb6BfjRgXHYx"

enum YelpService {
    enum BusinessProvider: TargetType {
        var baseURL: URL {
            return URL(string: "https://api.yelp.com/v3/businesses")!
        }
        
        var path: String {
            switch self {
            case .search:
                return "/search"
            }
        }
        
        var method: Moya.Method {
            return .get
        }
        
        var sampleData: Data {
            return Data()
        }
        
        var task: Task {
            switch self {
            case .search(let lat, let long):
                return .requestParameters(parameters: ["latitude" : lat, "longitude": long, "limit": 1], encoding: URLEncoding.queryString)
            }
        }
        
        var headers: [String : String]? {
            return ["Authorization": "Bearer \(apiKey)"]
        }
    }
}

final class NetworkService: NSObject {
    
}
