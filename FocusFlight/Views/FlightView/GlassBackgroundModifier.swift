//
//  File.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 26.01.2026.
//

import Foundation
import SwiftUI

// Модификатор для элементов с полупрозрачным фоном
struct GlassBackgorundModifer: ViewModifier {
    
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(0.3), radius: 5)
    }
}

extension View {
    func glassBackgorund(cornerRadius: CGFloat = 16) -> some View {
        modifier(GlassBackgorundModifer(cornerRadius: cornerRadius))
    }
}
