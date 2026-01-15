//
//  AirportLoadingService.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 15.01.2026.
//

import Foundation
import Combine

class AirportLoadingService: ObservableObject {
    
    @Published var airports: [Airport] = []
    
    func loadAllAirports() {
        
        let decoder = JSONDecoder()
        
        guard let path = Bundle.main.path(forResource: "airports", ofType: "json") else {
            print("File not found")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try decoder.decode([Airport].self, from: data)
            airports = decoded
        } catch {
            print("File reading error: \(error)")
        }
    }
}
