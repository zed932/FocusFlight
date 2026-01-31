//
//  WeatherService.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 16.01.2026.
//

import Foundation

final class WeatherService {

    func getCurrentWeather(latitude: Double, longitude: Double) async throws -> CurrentWeatherResponse? {
        // TODO: для продакшена вынести в Secure/Config (например xcconfig, не коммитить ключ)
        let apiKey = "a2092311efa2911bfa671612d9e9af78"
        
        let weatherDecoder = JSONDecoder()
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try weatherDecoder.decode(CurrentWeatherResponse.self, from: data)
    }
}
