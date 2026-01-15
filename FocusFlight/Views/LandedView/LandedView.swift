//
//  LandedView.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 15.01.2026.
//

import SwiftUI

struct LandedView: View {
    
    var flight: Flight
    
    //var weather: Weather?
    
    var weatherSevice =  WeatherService()
    
    @StateObject var userDefaultsService = UserDefaultsFlightHistory()
    @State var currentWeather: CurrentWeatherResponse?
    
    var body: some View {
        VStack {
            Text("You are landed at \(flight.toAirport.municipality)!")
                .font(Font.largeTitle.bold())
            
            Text("Weahter at \(flight.toAirport.municipality) is:")
            
            if let weather = currentWeather {
                VStack(spacing: 20) {
                    Text("Temperature is: \(Int(weather.main.temp))")
                    Text("Feels like: \(Int(weather.main.feelsLike))")
                }
            } else {
                ProgressView("Loading weather...")
            }
        }
        .task {
            await loadWeather()
        }
        .onAppear {
            userDefaultsService.saveNewFlight(flight: flight)
        }
        
    }
       
        
    
    private func loadWeather() async {
        
        guard let lon = flight.toAirport.longitudeDouble, let lat = flight.toAirport.latitudeDouble else { return }
        do {
            currentWeather = try await weatherSevice.getCurrentWeather(latitude: lat, longitude: lon)
        } catch {
            print("Error: \(Error.self)")
        }
    }
    
}

