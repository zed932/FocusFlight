//
//  BookFlightView.swift
//  FocusFlight
//

import SwiftUI

struct BookFlightView: View {
    @EnvironmentObject var flightHistory: FlightHistoryService
    @StateObject private var viewModel = BookFlightViewModel()
    @Binding var path: [Screen]

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                if let origin = viewModel.origin {
                    Text("From \(origin.municipality) (\(origin.iata_code))")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.white.opacity(0.6))
                }

                Text("How long do you want to focus?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                durationWheel

                Text("Destinations in \(DurationPickerConstants.label(minutes: viewModel.selectedDurationMinutes)) (±10 min)")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.65))

                if !viewModel.airportsInRange.isEmpty {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        TextField("Filter destinations...", text: $viewModel.searchText)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    .padding(10)
                    .background(Color(white: 0.2))
                    .clipShape(RoundedRectangle(cornerRadius: Theme.smallCornerRadius))
                    .padding(.horizontal, Theme.padding)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, Theme.padding)

            ScrollView {
                destinationList
                    .padding(.bottom, 16)
            }
            .frame(maxHeight: .infinity)

            createFlightButton
                .padding(.horizontal, Theme.padding)
                .padding(.top, 12)
                .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            GlobeBackgroundView(
                center: viewModel.origin?.coordinate,
                blurred: true
            )
        }
        .onAppear {
            viewModel.flightHistory = flightHistory
            viewModel.loadAirports()
        }
    }

    private var durationWheel: some View {
        Picker("Duration", selection: $viewModel.selectedDurationMinutes) {
            ForEach(DurationPickerConstants.durationOptions, id: \.self) { minutes in
                Text(DurationPickerConstants.label(minutes: minutes)).tag(minutes)
            }
        }
        .pickerStyle(.wheel)
        .frame(height: 140)
    }

    private var destinationList: some View {
        Group {
            if viewModel.origin == nil {
                Text("No origin airport set")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(height: 120)
            } else if viewModel.filteredAirports.isEmpty {
                Text("No airports in this range. Try another duration.")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .frame(minHeight: 120)
                    .padding()
            } else {
                VStack(spacing: 0) {
                    ForEach(viewModel.filteredAirports) { airport in
                        let minutes = viewModel.origin.flatMap { Flight.durationMinutes(from: $0, to: airport) }
                        BookFlightAirportRow(
                            airport: airport,
                            durationMinutes: minutes,
                            isSelected: viewModel.selectedDestination?.id == airport.id
                        )
                        .onTapGesture {
                            viewModel.selectedDestination = airport
                        }
                    }
                }
            }
        }
    }

    private var createFlightButton: some View {
        Button {
            guard let flight = viewModel.createFlight() else { return }
            path.append(.CheckInView(flight))
        } label: {
            Text("Create flight")
                .font(.headline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
        .foregroundStyle(.black)
        .disabled(viewModel.selectedDestination == nil || viewModel.origin == nil)
        .opacity(viewModel.selectedDestination == nil ? 0.6 : 1)
    }
}

private struct BookFlightAirportRow: View {
    let airport: Airport
    let durationMinutes: Double?
    let isSelected: Bool

    var body: some View {
        HStack {
            AirportRow(airport: airport, isSelected: isSelected)
            if let min = durationMinutes {
                Text("\(Int(min)) min")
                    .font(Theme.monospacedSmall)
                    .foregroundStyle(Theme.secondary)
            }
        }
        .padding(.horizontal, Theme.padding)
        .padding(.vertical, 8)
        .background(isSelected ? Color.blue.opacity(0.15) : Color.clear)
    }
}
