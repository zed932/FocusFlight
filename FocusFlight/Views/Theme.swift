import SwiftUI

struct Theme {
    // Цветовая палитра с поддержкой темной темы
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)
    
    static let primary = Color(.label)
    static let secondary = Color(.secondaryLabel)
    static let tertiary = Color(.tertiaryLabel)
    static let accent = Color.blue
    
    // Моноширинные шрифты для цифр и кодов
    static let monospacedLarge = Font.system(.largeTitle, design: .monospaced).weight(.bold)
    static let monospacedMedium = Font.system(.title2, design: .monospaced).weight(.semibold)
    static let monospacedSmall = Font.system(.body, design: .monospaced)
    static let monospacedCaption = Font.system(.caption, design: .monospaced)
    
    // Обычные шрифты
    static let titleFont = Font.system(.title, weight: .bold)
    static let headingFont = Font.system(.headline, weight: .semibold)
    static let bodyFont = Font.system(.body, weight: .regular)
    static let captionFont = Font.system(.caption, weight: .regular)
    
    // Размеры
    static let cornerRadius: CGFloat = 12
    static let smallCornerRadius: CGFloat = 8
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8
    
    // Градиенты для прогресс-бара
    static let progressGradient = LinearGradient(
        colors: [Color.blue, Color.cyan],
        startPoint: .leading,
        endPoint: .trailing
    )
}
