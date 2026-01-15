//
//  FlightsHistory.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 15.01.2026.
//

import SwiftUI


struct FlightsHistoryView: View {
    
    @StateObject var userDefaultsService = UserDefaultsFlightHistory()
    
    var body: some View {
        VStack {
            List {
                ForEach(userDefaultsService.flights, id: \.self) { flight in
                    HStack {
                        Text("Flight from: \(flight.fromAirport.iata_code)")
                        Text("Flight to: \(flight.toAirport.iata_code)")
                    }
                }
            }
        }
        .onAppear {
            userDefaultsService.loadAllFlights()
        }
    }
}

