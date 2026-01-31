//
//  LandedViewModel.swift
//  FocusFlight
//
//  Логика экрана приземления: погода и завершение полёта.
//

import SwiftUI
import Combine

@MainActor
final class LandedViewModel: ObservableObject {
    let flight: Flight
    @Published var currentWeather: CurrentWeatherResponse?

    weak var flightHistory: FlightHistoryService?
    private let weatherService = WeatherService()

    init(flight: Flight) {
        self.flight = flight
    }

    func loadWeather() async {
        guard let lon = flight.toAirport.longitudeDouble, let lat = flight.toAirport.latitudeDouble else { return }
        do {
            currentWeather = try await weatherService.getCurrentWeather(latitude: lat, longitude: lon)
        } catch {
            print("Error: \(error)")
        }
    }

    func completeFlight() {
        flightHistory?.completeLastFlight()
    }
}
