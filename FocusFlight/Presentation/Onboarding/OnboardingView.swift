//
//  OnboardingView.swift
//  FocusFlight
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var flightHistory: FlightHistoryService
    @StateObject private var viewModel = OnboardingViewModel()
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        VStack(spacing: 24) {
            Text("Choose your home airport")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 40)

            Text("This will be your starting point for focus flights")
                .font(.body)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            searchField
            airportList
            continueButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            GlobeBackgroundView(center: nil, blurred: true)
        }
        .onAppear {
            viewModel.flightHistory = flightHistory
            viewModel.loadAirports()
        }
    }

    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Search by city, name or code...", text: $viewModel.searchText)
                .focused($isSearchFocused)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(12)
        .background(Color(white: 0.2))
        .clipShape(RoundedRectangle(cornerRadius: Theme.smallCornerRadius))
        .padding(.horizontal, Theme.padding)
    }

    private var airportList: some View {
        Group {
            if viewModel.filteredAirports.isEmpty && !viewModel.searchText.isEmpty {
                Text("No airports found")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(maxHeight: 200)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.filteredAirports.prefix(200)) { airport in
                            AirportRow(
                                airport: airport,
                                isSelected: viewModel.selectedAirport?.id == airport.id
                            )
                            .padding(.horizontal, Theme.padding)
                            .padding(.vertical, 8)
                            .background(
                                viewModel.selectedAirport?.id == airport.id
                                ? Color.blue.opacity(0.15)
                                : Color.clear
                            )
                            .onTapGesture {
                                viewModel.selectedAirport = airport
                                isSearchFocused = false
                            }
                        }
                    }
                }
                .frame(maxHeight: 320)
            }
        }
    }

    private var continueButton: some View {
        Button {
            guard let airport = viewModel.selectedAirport else { return }
            viewModel.completeOnboarding(with: airport)
        } label: {
            Text("Continue")
                .font(.headline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
        .foregroundStyle(.black)
        .padding(.horizontal, 30)
        .padding(.bottom, 40)
        .disabled(viewModel.selectedAirport == nil)
        .opacity(viewModel.selectedAirport == nil ? 0.6 : 1)
    }
}
