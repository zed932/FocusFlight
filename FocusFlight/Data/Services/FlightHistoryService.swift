//
//  FlightHistoryService.swift
//  FocusFlight
//
//  Сервис истории полётов и состояния приложения. Компонует репозитории, экспонирует API для UI.
//

import Foundation
import Combine

final class FlightHistoryService: ObservableObject {

    @Published private(set) var storedFlights: [StoredFlight] = []
    @Published private(set) var homeAirport: Airport?
    @Published private(set) var currentOriginAirport: Airport?
    @Published private(set) var hasCompletedOnboarding: Bool = false

    var flights: [Flight] { storedFlights.map(\.flight) }
    var originForNextFlight: Airport? { currentOriginAirport ?? homeAirport }

    private let flightHistoryRepository: FlightHistoryRepositoryProtocol
    private let appStateRepository: AppStateRepositoryProtocol

    init(
        flightHistoryRepository: FlightHistoryRepositoryProtocol = UserDefaultsFlightHistoryRepository(),
        appStateRepository: AppStateRepositoryProtocol = UserDefaultsAppStateRepository()
    ) {
        self.flightHistoryRepository = flightHistoryRepository
        self.appStateRepository = appStateRepository
        syncFromRepositories()
    }

    func loadAllFlights() {
        storedFlights = flightHistoryRepository.loadFlights()
    }

    func saveNewFlight(flight: Flight) {
        storedFlights.append(StoredFlight(flight: flight, isCompleted: false))
        flightHistoryRepository.saveFlights(storedFlights)
    }

    func completeLastFlight() {
        guard let last = storedFlights.last else { return }
        var updated = storedFlights
        updated[updated.count - 1] = StoredFlight(flight: last.flight, isCompleted: true, id: last.id)
        storedFlights = updated
        flightHistoryRepository.saveFlights(storedFlights)
        appStateRepository.setCurrentOriginAirport(last.flight.toAirport)
    }

    func setHomeAirport(_ airport: Airport) {
        appStateRepository.setHomeAirport(airport)
        if appStateRepository.currentOriginAirport == nil {
            appStateRepository.setCurrentOriginAirport(airport)
        }
        syncAppStateFromRepository()
    }

    func completeOnboarding() {
        appStateRepository.setOnboardingCompleted(true)
        hasCompletedOnboarding = true
    }

    private func syncFromRepositories() {
        appStateRepository.load()
        hasCompletedOnboarding = appStateRepository.hasCompletedOnboarding
        homeAirport = appStateRepository.homeAirport
        currentOriginAirport = appStateRepository.currentOriginAirport
        storedFlights = flightHistoryRepository.loadFlights()
    }

    private func syncAppStateFromRepository() {
        homeAirport = appStateRepository.homeAirport
        currentOriginAirport = appStateRepository.currentOriginAirport
    }
}
