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

    /// Длительность полёта в часах (та же формула, что и для отображения).
    var time: Double {
        distance / 780000
    }

    /// Длительность полёта между двумя аэропортами в минутах (та же формула, что и `time`).
    static func durationMinutes(from: Airport, to: Airport) -> Double? {
        guard let fromCoord = from.coordinate, let toCoord = to.coordinate else { return nil }
        let km = fromCoord.distance(to: toCoord)
        return (km / 780) * 60
    }
}
