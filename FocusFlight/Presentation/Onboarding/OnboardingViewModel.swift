//
//  OnboardingViewModel.swift
//  FocusFlight
//
//  Логика экрана выбора домашнего аэропорта.
//

import SwiftUI
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var selectedAirport: Airport?
    @Published var searchText = ""

    weak var flightHistory: FlightHistoryService? { didSet { objectWillChange.send() } }
    private let airportLoadingService = AirportLoadingService()
    private var cancellables = Set<AnyCancellable>()

    var filteredAirports: [Airport] {
        if searchText.isEmpty {
            return airportLoadingService.airports
        }
        return airportLoadingService.airports.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.iata_code.localizedCaseInsensitiveContains(searchText) ||
            $0.municipality.localizedCaseInsensitiveContains(searchText) ||
            $0.iso_country.localizedCaseInsensitiveContains(searchText)
        }
    }

    init() {
        airportLoadingService.$airports
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    func loadAirports() {
        Task {
            await airportLoadingService.loadAllAirports()
        }
    }

    func completeOnboarding(with airport: Airport) {
        flightHistory?.setHomeAirport(airport)
        flightHistory?.completeOnboarding()
    }
}
