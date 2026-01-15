//
//  MainButtons.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 17.01.2026.
//

import SwiftUI

struct MainButtonsView: View {
    
    @Binding var path: [Screen]
    
    var body: some View {
        
        VStack(spacing: 6) {
            Button {
                path.append(.AirportSelectionView)
            } label: {
                Text("Book flight")
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            .modifier(MainButtonsModifier())
            
            
            Button {
                path.append(.FlightsHistoryView)
            } label: {
                Text("Flights history")
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            .modifier(MainButtonsModifier())

        }
    }
}


struct MainButtonsModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minHeight: 30)
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .foregroundStyle(.white)
    }
}
