//
//  DurationPickerConstants.swift
//  FocusFlight
//
//  Константы для выбора длительности полёта (одно место).
//

import Foundation

enum DurationPickerConstants {
    static let maxFlightDurationMinutes = 20 * 60

    static var durationOptions: [Int] {
        stride(from: 15, through: maxFlightDurationMinutes, by: 15).map { $0 }
    }

    static func label(minutes: Int) -> String {
        if minutes < 60 { return "\(minutes) min" }
        let h = minutes / 60
        let m = minutes % 60
        if m == 0 { return "\(h) h" }
        return "\(h) h \(m) min"
    }
}
