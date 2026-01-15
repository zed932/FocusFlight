//
//  ToAirportChoose.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 18.01.2026.
//

import Foundation
import SwiftUI

struct ToAirportChoose: View {
    @Binding var toAirport: Airport?
    let airports: [Airport]
    @Binding var searchText: String
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("To:")
                .font(.headline)
                .padding(.horizontal)
            
            // Строка поиска
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 12)
                
                TextField("Search airport by name, code or city...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .focused($isSearchFocused)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.vertical, 12)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 12)
                    }
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Список аэропортов
            if airports.isEmpty && !searchText.isEmpty {
                VStack {
                    Image(systemName: "airplane")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                        .padding()
                    Text("No airports found")
                        .foregroundColor(.gray)
                }
                .frame(height: 150)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(airports) { airport in
                            AirportRow(
                                airport: airport,
                                isSelected: toAirport?.id == airport.id
                            )
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(
                                toAirport?.id == airport.id ?
                                Color.blue.opacity(0.1) : Color.clear
                            )
                            .onTapGesture {
                                toAirport = airport
                                isSearchFocused = false
                            }
                            .animation(.easeInOut(duration: 0.2), value: toAirport?.id)
                        }
                    }
                }
                .frame(maxHeight: 300)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal)
            }
        }
    }
}
