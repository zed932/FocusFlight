//
//  CameraModeButton.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 26.01.2026.
//

import Foundation
import SwiftUI


struct CameraModeButton: View {
    
    let mode: CameraMode
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: mode == .following ? "location.fill" : "map")
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .glassBackgorund(cornerRadius: 22)
        }
    }
}


enum CameraMode {
    case overview
    case following
}
