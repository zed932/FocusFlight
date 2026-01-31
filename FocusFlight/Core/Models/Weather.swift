//
//  Weather.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 16.01.2026.
//

import Foundation

// MARK: - Current Weather Response
struct CurrentWeatherResponse: Codable {
    let coord: Coordinates
    let weather: [WeatherCondition]
    let base: String
    let main: MainWeatherInfo
    let visibility: Int
    let wind: WindInfo
    let rain: RainInfo?
    let clouds: CloudsInfo
    let dt: Date
    let sys: SystemInfo
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

// MARK: - Weather Condition
struct WeatherCondition: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - Main Weather Info
struct MainWeatherInfo: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    let seaLevel: Int?
    let grndLevel: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Wind Info
struct WindInfo: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

// MARK: - Rain Info
struct RainInfo: Codable {
    let oneHour: Double?
    let threeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHour = "3h"
    }
}

// MARK: - Clouds Info
struct CloudsInfo: Codable {
    let all: Int
}

// MARK: - System Info
struct SystemInfo: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
    let message: String?  // Для ошибок
    let pod: String?      // "d" для дня, "n" для ночи (в некоторых API версиях)
}
