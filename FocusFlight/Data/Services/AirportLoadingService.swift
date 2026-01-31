//
//  AirportLoadingService.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 15.01.2026.
//

import Foundation
import Combine

@MainActor
final class AirportLoadingService: ObservableObject {

    @Published var airports: [Airport] = []

    /// Загружает аэропорты в фоне, результат выставляет на главном потоке (без фриза UI).
    func loadAllAirports() async {
        let decoded = await Task.detached(priority: .userInitiated) {
            guard let path = Bundle.main.path(forResource: "airports", ofType: "json") else {
                return [Airport]()
            }
            let url = URL(fileURLWithPath: path)
            guard let data = try? Data(contentsOf: url),
                  let list = try? JSONDecoder().decode([Airport].self, from: data) else {
                return [Airport]()
            }
            return list
        }.value
        self.airports = decoded
    }
}
