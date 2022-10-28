//
//  NetworkingConstants.swift
//  MTH 
// 
//  Created by Sachin  on 04/03/21.
//

import Foundation
struct ApisURL {
    /// Base Url
    // MARK: - App URL's
    static let baseURl = "http://api.weatherstack.com/" //Local
//http://api.weatherstack.com/current?access_key=dca2525df9d6f96a77dd5f35e8ff4911&query=Chandigarh
    enum ServiceUrls: String {
        // Home
        case getCurrentWeather = "current?access_key=dca2525df9d6f96a77dd5f35e8ff4911"
    }
}
