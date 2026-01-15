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
        VStack {
            Text("Doors closed")
            Text("Get ready for a takeoff!")
            
            Button {
                path.removeLast()
                path.append(.FlightView(flight))
            } label: {
                Text("Take off")
            }
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .foregroundStyle(.white)
            .padding(.horizontal, 30)
        }
        .presentationBackground(.ultraThinMaterial)
    }
}

