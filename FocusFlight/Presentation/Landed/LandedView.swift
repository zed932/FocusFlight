//
//  LandedView.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 15.01.2026.
//

import SwiftUI

struct LandedView: View {
    let flight: Flight
    @Binding var path: [Screen]

    @EnvironmentObject var flightHistory: FlightHistoryService
    @StateObject private var viewModel: LandedViewModel

    init(flight: Flight, path: Binding<[Screen]>) {
        self.flight = flight
        self._path = path
        self._viewModel = StateObject(wrappedValue: LandedViewModel(flight: flight))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    Text("You landed in")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.8))

                    Text(flight.toAirport.municipality)
                        .font(.system(size: 38, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text(flight.toAirport.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.white.opacity(0.6))
                }
                .padding(.top, 24)

                weatherCard

                Spacer(minLength: 24)

                Button {
                    viewModel.completeFlight()
                    path.removeAll()
                } label: {
                    Text("End flight")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                .foregroundStyle(.black)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .scrollIndicators(.hidden)
        .task {
            await viewModel.loadWeather()
        }
        .onAppear {
            viewModel.flightHistory = flightHistory
            flightHistory.saveNewFlight(flight: flight)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            GlobeBackgroundView(
                center: flight.toAirport.coordinate,
                blurred: true
            )
        }
    }

    private var weatherCard: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "cloud.sun.fill")
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.9))
                Text("Weather")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.9))
                Spacer()
            }

            if let weather = viewModel.currentWeather {
                HStack(spacing: 32) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Temperature")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.6))
                        Text("\(Int(weather.main.temp))°")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Feels like")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.6))
                        Text("\(Int(weather.main.feelsLike))°")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    Spacer()
                }
            } else {
                HStack(spacing: 8) {
                    ProgressView()
                        .tint(.white)
                    Text("Loading weather...")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
        .padding(24)
        .background(.black.opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                .stroke(.white.opacity(0.15), lineWidth: 1)
        )
        .padding(.horizontal, 24)
    }
}
