

import SwiftUI
import Combine

struct AirportSelectionView: View {
    @StateObject var airportsLoadingService = AirportLoadingService()
    @State private var fromAirport: Airport?
    @State private var toAirport: Airport?
    @State private var searchFromText = ""
    @State private var searchToText = ""
    
    @State var isPopoverShoved = false
    
    @Binding var path: [Screen]
    
    // Фильтрованные аэропорты для "From"
    var filteredFromAirports: [Airport] {
        if searchFromText.isEmpty {
            return airportsLoadingService.airports
        } else {
            return airportsLoadingService.airports.filter {
                $0.name.localizedCaseInsensitiveContains(searchFromText) ||
                $0.iata_code.localizedCaseInsensitiveContains(searchFromText) ||
                $0.municipality.localizedCaseInsensitiveContains(searchFromText) ||
                $0.iso_country.localizedCaseInsensitiveContains(searchFromText)
            }
        }
    }
    
    // Фильтрованные аэропорты для "To"
    var filteredToAirports: [Airport] {
        if searchToText.isEmpty {
            return airportsLoadingService.airports
        } else {
            return airportsLoadingService.airports.filter {
                $0.name.localizedCaseInsensitiveContains(searchToText) ||
                $0.iata_code.localizedCaseInsensitiveContains(searchToText) ||
                $0.municipality.localizedCaseInsensitiveContains(searchToText) ||
                $0.iso_country.localizedCaseInsensitiveContains(searchToText)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Choose your destination")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)
                
                FromAirportChoose(
                    fromAirport: $fromAirport,
                    airports: filteredFromAirports,
                    searchText: $searchFromText
                )
                
                ToAirportChoose(
                    toAirport: $toAirport,
                    airports: filteredToAirports,
                    searchText: $searchToText
                )
                
                Button {
                    guard let from = fromAirport,
                          let to = toAirport,
                          from.id != to.id else {
                        return
                    }
                    
                    let flight = Flight(fromAirport: from, toAirport: to)
                    path.append(.CheckInView(flight))
                    
                } label: {
                    Text("Create flight")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.white)
                .padding(.horizontal, 30)
                .disabled(fromAirport == nil || toAirport == nil || fromAirport?.id == toAirport?.id)
                .opacity((fromAirport == nil || toAirport == nil || fromAirport?.id == toAirport?.id) ? 0.6 : 1)
            }
            .padding(.vertical)
        }
        .onAppear {
            Task {
                await airportsLoadingService.loadAllAirports()
            }
        }
    }
}




