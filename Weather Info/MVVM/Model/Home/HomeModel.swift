//
//  HomeModel.swift
//  Weather Info
//
//  Created by Sachin on 28/10/22.
//

import Foundation
class HomeModel {
    var dataResponse: GetWeather?
    var currentLoc: String?
}

// MARK: - GetWeather
struct GetWeather: Codable {
    let request: Request?
    let location: Location?
    let current: Current?
}

// MARK: - Current
struct Current: Codable {
    let weatherIcons: [String]?
    let weatherDescriptions: [String]?
    let windSpeed: Double?
    let pressure, precip, temperature: Double?

    enum CodingKeys: String, CodingKey {
        case weatherIcons = "weather_icons"
        case weatherDescriptions = "weather_descriptions"
        case windSpeed = "wind_speed"
        case pressure, precip, temperature
    }
}

// MARK: - Location
struct Location: Codable {
    let name, country, region, lat: String?
    let lon, timezoneID, localtime: String?
    let utcOffset: String?

    enum CodingKeys: String, CodingKey {
        case name, country, region, lat, lon
        case timezoneID = "timezone_id"
        case localtime
        case utcOffset = "utc_offset"
    }
}

// MARK: - Request
struct Request: Codable {
    let type, query, language, unit: String?
}
