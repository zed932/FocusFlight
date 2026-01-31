//
//  FlightMetrics.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 26.01.2026.
//

import SwiftUI

struct FlightMetricsView: View {
    
    let remainingTime: TimeInterval
    let remainingDistance: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text("Map data Apple")
                .font(.system(size: 10, weight: .regular))
                .foregroundStyle(.white.opacity(0.5))
                .padding(.leading, 30)
            
            // Основные метрики
            HStack(spacing: 20) {
                
                // Время
                TimeView(remainingTime: remainingTime)
                
                // Разделитель
                Text("|")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundStyle(.white.opacity(0.3))
                
                // Расстояние
                DistanceView(remainingDistance: remainingDistance)
                
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
            .glassBackground(cornerRadius: 16)
        }
    }
    
}

// View таймера обратного отсчета времени

struct TimeView: View {
    
    let remainingTime: TimeInterval
    
    private var formattedTime: String {
        let totalSeconds = Int(remainingTime)
        
        if totalSeconds >= 3600 {
            let hours = totalSeconds / 3600
            let minutes = (totalSeconds % 3600) / 60
            return String(format: "%02d:%02d", hours, minutes)
        } else if totalSeconds >= 60 {
            let minutes = totalSeconds / 60
            // let seconds = totalSeconds % 60
            return String(format: "%02d", minutes)
        } else {
            return String(format: "%02d", totalSeconds)
        }
    }
    
    private var timeUnit: String {
        let totalSeconds = Int(remainingTime)
            
        if totalSeconds >= 3600 {
            return "h"
        } else if totalSeconds >= 60 {
            return "min."
        } else  {
            return "secs."
        }
    }
    
    
    // Используем количество времени и единицы измерения
    // вычисленные в свойствах formattedTime (кол-во)
    // и timeUnit (единицы измерения: часы, минуты, секунды)
    
    var body: some View {
        HStack(spacing: 4) {
            Text(formattedTime)
                .font(.system(size: 38, weight: .bold, design: .monospaced))
                .foregroundStyle(.white)
            
            Text(timeUnit)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white.opacity(0.85))
        }
    }
}

// View таймера обратного отсчета расстояния

struct DistanceView: View {
    
    let remainingDistance: Double
    
    private var formattedDistance: String {
        if remainingDistance >= 100 {
            return String(format: "%0.f", remainingDistance)
        } else if remainingDistance >= 1 {
            return String(format: "%.1f", remainingDistance)
        } else {
            return String(format: "%.0f", remainingDistance * 1000)
        }
    }
    
    private var distanceUnit: String {
        
        if remainingDistance >= 1 {
            return "km"
        } else {
            return "m"
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Text(formattedDistance)
                .font(.system(size: 38, weight: .bold, design: .monospaced))
                .foregroundStyle(.white)
            Text(distanceUnit)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white.opacity(0.85))
        }
    }
}

