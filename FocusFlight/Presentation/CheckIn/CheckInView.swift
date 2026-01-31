//
//  CheckInView.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 19.01.2026.
//

import SwiftUI

struct CheckInView: View {

    @Binding var path: [Screen]
    let flight: Flight

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Text("Doors closed")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.white)
            Text("Get ready for a takeoff!")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.white.opacity(0.75))

            Spacer()

            Button {
                path.removeLast()
                path.append(.FlightView(flight))
            } label: {
                Text("Take off")
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            .modifier(MainButtonsModifier())
            .frame(maxWidth: 350)
        }
        .padding(Theme.padding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            GlobeBackgroundView(
                center: flight.fromAirport.coordinate,
                blurred: true
            )
        }
    }
}

