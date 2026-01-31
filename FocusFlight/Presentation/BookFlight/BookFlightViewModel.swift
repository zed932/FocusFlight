//
//  BookFlightViewModel.swift
//  FocusFlight
//
//  Логика экрана выбора длительности и аэропорта назначения.
//

import SwiftUI
import Combine

@MainActor
final class BookFlightViewModel: ObservableObject {
    @Published var selectedDurationMinutes: Int = 30
    @Published var selectedDestination: Airport?
    @Published var searchText = ""

    weak var flightHistory: FlightHistoryService? { didSet { objectWillChange.send() } }
    private let airportLoadingService = AirportLoadingService()
    private var cancellables = Set<AnyCancellable>()

    var origin: Airport? { flightHistory?.originForNextFlight }
    var airports: [Airport] { airportLoadingService.airports }

    init() {
        airportLoadingService.$airports
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    var airportsInRange: [Airport] {
        guard let from = origin else { return [] }
        let low = Double(selectedDurationMinutes - 10)
        let high = Double(selectedDurationMinutes + 10)
        return airportLoadingService.airports.filter { airport in
            guard airport.id != from.id,
                  let minutes = Flight.durationMinutes(from: from, to: airport) else { return false }
            return minutes >= max(5, low) && minutes <= high
        }
    }

    var filteredAirports: [Airport] {
        if searchText.isEmpty {
            return Array(airportsInRange.prefix(150))
        }
        return airportsInRange.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.iata_code.localizedCaseInsensitiveContains(searchText) ||
            $0.municipality.localizedCaseInsensitiveContains(searchText)
        }
    }

    func loadAirports() {
        Task {
            await airportLoadingService.loadAllAirports()
        }
    }

    func createFlight() -> Flight? {
        guard let from = origin, let to = selectedDestination, from.id != to.id else { return nil }
        return Flight(fromAirport: from, toAirport: to)
    }
}
