//
//  FocusFlightApp.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 15.01.2026.
//

import SwiftUI

@main
struct FocusFlightApp: App {
    @StateObject private var flightHistory = FlightHistoryService()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(flightHistory)
        }
    }
}
