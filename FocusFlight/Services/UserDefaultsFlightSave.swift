//
//  UserDefaultsFlightSave.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 15.01.2026.
//

import Foundation
import Combine

class UserDefaultsFlightHistory: ObservableObject {
    
    var flights: [Flight] = []
    private var flightsKey = "savedFlights"
    
    func saveAllFlights() {
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(flights)
            UserDefaults.standard.set(data, forKey: flightsKey)
        } catch {
            print("Error saving flights: \(error)")
        }
        
    }
    
    func saveNewFlight(flight: Flight) {
        flights.append(flight)
        saveAllFlights()
    }
    
    func loadAllFlights() -> [Flight] {
       
        let decoder = JSONDecoder()
        
        guard let savedData = UserDefaults.standard.object(forKey: flightsKey), let decodedFlights = try? decoder.decode([Flight].self, from: savedData as! Data) else { return [] }
            return decodedFlights
    }
    
    init() {
        self.flights = loadAllFlights()
    }
    
}
