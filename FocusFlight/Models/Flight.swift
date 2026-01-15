//
//  Flight.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 15.01.2026.
//


struct Flight: Hashable, Codable {
    
    let fromAirport: Airport
    let toAirport: Airport
    
    var distance: Double {
        guard let fromCoord = fromAirport.coordinate, let toCoord = toAirport.coordinate else { return 0 }
        return fromCoord.distance(to: toCoord)
    }
    
    var time: Double {
        return distance / 70000
    }
    
}
