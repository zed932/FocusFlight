//
//  FlightHistoryRepository.swift
//  FocusFlight
//
//  Репозиторий полётов (персистенция). Один источник правды для сохранённых полётов.
//

import Foundation

protocol FlightHistoryRepositoryProtocol: AnyObject {
    func loadFlights() -> [StoredFlight]
    func saveFlights(_ flights: [StoredFlight])
}

final class UserDefaultsFlightHistoryRepository: FlightHistoryRepositoryProtocol {
    private let key = "savedFlights"

    func loadFlights() -> [StoredFlight] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        if let decoded = try? JSONDecoder().decode([StoredFlight].self, from: data) {
            return decoded
        }
        if let legacy = try? JSONDecoder().decode([Flight].self, from: data) {
            return legacy.map { StoredFlight(flight: $0, isCompleted: false) }
        }
        return []
    }

    func saveFlights(_ flights: [StoredFlight]) {
        guard let data = try? JSONEncoder().encode(flights) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
