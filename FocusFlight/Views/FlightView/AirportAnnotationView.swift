//
//  AirportAnnotationView.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 26.01.2026.
//

import Foundation
import SwiftUI
import MapKit


// Иконки для departure / arriving аэропортов
// Внутрь передаем название картинки (вылет / прилет)
// также внутрь передаем цвет иконки прилета и вылета

struct AirportAnnotationView: View {
    
    let systemName: String
    let color: Color
    
    var body: some View {
        Image(systemName: systemName)
            .font(.title2)
            .foregroundStyle(.white)
            .padding(8)
            .background(color)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 2)
            )
            .shadow(radius: 3)
    }
}
