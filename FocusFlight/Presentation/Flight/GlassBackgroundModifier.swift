//
//  GlassBackgroundModifier.swift
//  FocusFlight
//
//  Модификатор для элементов с полупрозрачным фоном (glass effect).
//

import SwiftUI

struct GlassBackgroundModifier: ViewModifier {
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(0.3), radius: 5)
    }
}

extension View {
    func glassBackground(cornerRadius: CGFloat = 16) -> some View {
        modifier(GlassBackgroundModifier(cornerRadius: cornerRadius))
    }
}
