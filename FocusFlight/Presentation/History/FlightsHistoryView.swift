//
//  FlightsHistory.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 15.01.2026.
//

import SwiftUI

struct FlightsHistoryView: View {
    
    @EnvironmentObject var flightHistory: FlightHistoryService
    
    var body: some View {
        Group {
            if flightHistory.flights.isEmpty {
                emptyState
            } else {
                listContent
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
        .onAppear {
            flightHistory.loadAllFlights()
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "airplane.circle")
                .font(.system(size: 56))
                .foregroundStyle(.white.opacity(0.5))
            Text("No flights yet")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            Text("Complete a focus flight to see it here")
                .font(.body)
                .foregroundStyle(.white.opacity(0.65))
                .multilineTextAlignment(.center)
        }
        .padding(Theme.padding)
    }
    
    private var listContent: some View {
        List {
            ForEach(flightHistory.storedFlights) { stored in
                FlightHistoryRow(storedFlight: stored)
                    .listRowBackground(Color(red: 0.2, green: 0.2, blue: 0.2))
                    .listRowSeparatorTint(.white.opacity(0.2))
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

private struct FlightHistoryRow: View {
    let storedFlight: StoredFlight
    private var flight: Flight { storedFlight.flight }
    
    private var durationText: String {
        let hours = Int(flight.time)
        let minutes = Int((flight.time - Double(hours)) * 60)
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(flight.fromAirport.iata_code)
                        .font(Theme.monospacedMedium)
                        .foregroundStyle(.white)
                    Image(systemName: "arrow.right")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                    Text(flight.toAirport.iata_code)
                        .font(Theme.monospacedMedium)
                        .foregroundStyle(.white)
                }
                Text("\(flight.fromAirport.municipality) → \(flight.toAirport.municipality)")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.65))
                    .lineLimit(1)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                if storedFlight.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.body)
                }
                Text(durationText)
                    .font(Theme.monospacedSmall)
                    .foregroundStyle(.white.opacity(0.8))
                Text("\(Int(flight.distance / 1000)) km")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .padding(.vertical, 6)
    }
}

