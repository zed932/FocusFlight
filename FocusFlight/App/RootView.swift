//
//  RootView.swift
//  FocusFlight
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var flightHistory: FlightHistoryService

    var body: some View {
        Group {
            if flightHistory.hasCompletedOnboarding {
                MainView()
            } else {
                OnboardingView()
            }
        }
    }
}
