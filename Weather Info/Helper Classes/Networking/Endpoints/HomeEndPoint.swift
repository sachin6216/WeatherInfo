//
//  HomeEndPoint.swift
//
//  Created by Sachin  on 04/03/21.
//
import Foundation
import UIKit
import Alamofire
enum HomeEndPoint: TargetType {
    
    case getCurrentWeather(query: String)
    var data: [String: Any] {
        switch self {
        case .getCurrentWeather(query: let query):
            return [
                "query": query
            ]
        }
    }
    var service: String {
        switch self {
        case .getCurrentWeather: return ApisURL.ServiceUrls.getCurrentWeather.rawValue
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCurrentWeather:
            return .get
        }
    }
    
    var isJSONRequest: Bool {
        switch self {
        case .getCurrentWeather:
            return false
        }
    }
    var multipartBody: MulitPartParam? {
        switch self {
        default:
            return nil
        }
    }
    var headers: [String: String]? {
        return nil
    }
    var instance: ApiManager {
        return .init(targetData: self)
    }
}
