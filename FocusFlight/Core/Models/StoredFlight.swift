//
//  StoredFlight.swift
//  FocusFlight
//

import Foundation

/// Полёт в истории с флагом завершённости (пролетел ли пользователь до конца).
struct StoredFlight: Codable, Identifiable {
    let id: UUID
    let flight: Flight
    var isCompleted: Bool

    init(flight: Flight, isCompleted: Bool = false, id: UUID = UUID()) {
        self.id = id
        self.flight = flight
        self.isCompleted = isCompleted
    }
}
