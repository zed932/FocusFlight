//
//  Plane.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 26.01.2026.
//

import SwiftUI

// View самого самолета: Внутрь передается угол наклона
// для корректного поворота относительно маршрута

struct PlaneView: View {
    
    let heading: Double
    
    var body: some View {
        Image(systemName: "airplane")
            .font(.title2)
            .foregroundStyle(.white)
            .rotationEffect(.degrees(heading))
            .shadow(color: .black, radius: 3)
    }
}

