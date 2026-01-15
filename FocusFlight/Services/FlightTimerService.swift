//
//  FlightTimerService.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 15.01.2026.
//

import Foundation
import Combine

class FlightTimerService: ObservableObject {
    @Published var remainingTime: TimeInterval = 0
    @Published var isRunning = false
    @Published var progress: Double = 0
    
    private var totalTime: TimeInterval = 0 //Общая длительность
    private var timer: Timer? // Объект таймера
    private var startDate: Date? // Время начала отсчета
    
    func startTimer(totalFlightTime: TimeInterval) {
        self.totalTime = totalFlightTime
        self.remainingTime = totalFlightTime
        self.isRunning = true
        self.startDate = Date()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, let startDate = self.startDate else { return }
            
            let elapsed = Date().timeIntervalSince(startDate)
            self.remainingTime = max(0, totalFlightTime - elapsed)
            self.progress = min(1.0, elapsed / totalFlightTime)
            
            if self.remainingTime <= 0 {
                self.stopTimer()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
    
    func resetTimer() {
        stopTimer()
        remainingTime = totalTime
        progress = 0
    }
}
