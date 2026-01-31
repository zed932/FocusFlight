//
//  AppStateRepository.swift
//  FocusFlight
//
//  Репозиторий состояния приложения: домашний аэропорт, текущая точка вылета, онбординг.
//

import Foundation

protocol AppStateRepositoryProtocol: AnyObject {
    var hasCompletedOnboarding: Bool { get }
    var homeAirport: Airport? { get }
    var currentOriginAirport: Airport? { get }
    func setOnboardingCompleted(_ value: Bool)
    func setHomeAirport(_ airport: Airport?)
    func setCurrentOriginAirport(_ airport: Airport?)
    func load()
}

final class UserDefaultsAppStateRepository: AppStateRepositoryProtocol {
    private let onboardingKey = "hasCompletedOnboarding"
    private let homeAirportKey = "homeAirport"
    private let currentOriginKey = "currentOriginAirport"

    private(set) var hasCompletedOnboarding: Bool = false
    private(set) var homeAirport: Airport?
    private(set) var currentOriginAirport: Airport?

    func setOnboardingCompleted(_ value: Bool) {
        hasCompletedOnboarding = value
        UserDefaults.standard.set(value, forKey: onboardingKey)
    }

    func setHomeAirport(_ airport: Airport?) {
        homeAirport = airport
        saveHomeAirport()
    }

    func setCurrentOriginAirport(_ airport: Airport?) {
        currentOriginAirport = airport
        saveCurrentOrigin()
    }

    func load() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)
        homeAirport = decodeAirport(forKey: homeAirportKey)
        currentOriginAirport = decodeAirport(forKey: currentOriginKey) ?? homeAirport
    }

    private func decodeAirport(forKey key: String) -> Airport? {
        guard let data = UserDefaults.standard.data(forKey: key),
              let airport = try? JSONDecoder().decode(Airport.self, from: data) else { return nil }
        return airport
    }

    private func saveHomeAirport() {
        guard let airport = homeAirport, let data = try? JSONEncoder().encode(airport) else { return }
        UserDefaults.standard.set(data, forKey: homeAirportKey)
    }

    private func saveCurrentOrigin() {
        guard let airport = currentOriginAirport, let data = try? JSONEncoder().encode(airport) else { return }
        UserDefaults.standard.set(data, forKey: currentOriginKey)
    }
}
