//
//  AirportRow.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 18.01.2026.
//

import SwiftUI

struct AirportRow: View {
    let airport: Airport
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "airplane.circle.fill")
                .font(.title2)
                .foregroundColor(isSelected ? .blue : .gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(airport.name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? .blue : .primary)
                
                HStack {
                    Text("\(airport.municipality), \(airport.iso_country)")
                        .font(.subheadline)
                        .foregroundColor(isSelected ? .blue.opacity(0.85) : .secondary)
                    
                    if !airport.iata_code.isEmpty {
                        Text("•")
                            .font(.caption)
                            .foregroundColor(.secondary.opacity(0.8))
                        
                        Text(airport.iata_code)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(isSelected ? .blue : .secondary)
                    }
                }
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
