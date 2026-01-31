//
//  FlightViewModel.swift
//  FocusFlight
//
//  ViewModel экрана полёта. Зависимости внедряются через протоколы (SOLID).
//

import SwiftUI
import MapKit
import Combine

@MainActor
final class FlightViewModel: ObservableObject {
    let flight: Flight
    let timerService: FlightTimerService
    let soundService: SoundService
    let mapService: MapServiceProtocol

    @Published var cameraPosition: MapCameraPosition = .automatic
    @Published var cameraMode: CameraMode = .following
    @Published var planeHeading: Double = 0
    @Published var greatCirclePath: [CLLocationCoordinate2D] = []
    @Published var mapStyle: MapStyle = .hybrid(elevation: .realistic)

    private var cancellables = Set<AnyCancellable>()

    var currentPlanePosition: CLLocationCoordinate2D {
        guard let from = flight.fromAirport.coordinate,
              let to = flight.toAirport.coordinate else {
            return CLLocationCoordinate2D()
        }
        let progress = timerService.progress
        return mapService.intermediatePoint(from: from, to: to, fraction: progress)
    }

    var remainingDistance: Double {
        flight.distance * (1 - timerService.progress)
    }

    init(
        flight: Flight,
        timerService: FlightTimerService = FlightTimerService(),
        soundService: SoundService = SoundService(),
        mapService: MapServiceProtocol = MapService.shared
    ) {
        self.flight = flight
        self.timerService = timerService
        self.soundService = soundService
        self.mapService = mapService
        setupBindings()
    }
    
    private func setupBindings() {
        timerService.$progress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updatePlanePosition()
                if self?.cameraMode == .following {
                    self?.updateCameraPosition()
                }
            }
            .store(in: &cancellables)
    }
    
    func onAppear() {
        Task {
            await prepareFlightStart()
        }
    }

    /// Тяжёлые расчёты (маршрут, курс) — в фоне, UI не блокируется.
    private func prepareFlightStart() async {
        guard let from = flight.fromAirport.coordinate, let to = flight.toAirport.coordinate else { return }
        let path = await Task.detached(priority: .userInitiated) {
            MapService.shared.calculateGreatCirclePath(from: from, to: to, steps: 100)
        }.value
        let heading = await Task.detached(priority: .userInitiated) {
            MapService.shared.calculateCorrectedBearing(from: from, to: to)
        }.value
        greatCirclePath = path
        planeHeading = heading
        updateCameraPosition()
        playSounds()
        timerService.startTimer(totalFlightTime: flight.time * 3600)
    }
    
    func onDisappear() {
        timerService.stopTimer()
        soundService.stop()
    }
    
    func toggleCameraMode() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            cameraMode = cameraMode == .following ? .overview : .following
            updateCameraPosition()
        }
    }
    
    private func calculateGreatCirclePath() {
        guard let from = flight.fromAirport.coordinate,
              let to = flight.toAirport.coordinate else {
            greatCirclePath = []
            return
        }
        greatCirclePath = mapService.calculateGreatCirclePath(from: from, to: to, steps: 100)
    }
    
    private func setupInitialPlaneHeading() {
        guard let from = flight.fromAirport.coordinate,
              let to = flight.toAirport.coordinate else { return }
        
        planeHeading = mapService.calculateCorrectedBearing(from: from, to: to)
    }
    
    private func updatePlanePosition() {
        guard greatCirclePath.count > 1 else { return }
        
        let progress = timerService.progress
        
        // Плавное обновление направления самолета
        if progress > 0 && progress < 1 {
            let nextIndex = min(Int(progress * Double(greatCirclePath.count - 1)) + 1, greatCirclePath.count - 1)
            let prevIndex = max(0, nextIndex - 1)
            
            if prevIndex < nextIndex && nextIndex < greatCirclePath.count {
                let prevPoint = greatCirclePath[prevIndex]
                let nextPoint = greatCirclePath[nextIndex]
                
                let newHeading = mapService.calculateCorrectedBearing(from: prevPoint, to: nextPoint)
                withAnimation(.linear(duration: 0.5)) {
                    planeHeading = newHeading
                }
            }
        } else if progress >= 1, let from = flight.fromAirport.coordinate, let to = flight.toAirport.coordinate {
            // В конце маршрута используем направление к конечной точке
            let newHeading = mapService.calculateCorrectedBearing(from: from, to: to)
            withAnimation(.linear(duration: 0.5)) {
                planeHeading = newHeading
            }
        }
    }
    
    func updateCameraPosition() {
        guard let from = flight.fromAirport.coordinate,
              let to = flight.toAirport.coordinate else { return }
        
        switch cameraMode {
        case .overview:
            let camera = mapService.calculateOverviewCameraPosition(from: from, to: to)
            withAnimation(.easeInOut(duration: 1.5)) {
                cameraPosition = .camera(camera)
            }
            
        case .following:
            let camera = mapService.calculateFollowingCameraPosition(
                planePosition: currentPlanePosition,
                planeHeading: planeHeading
            )
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                cameraPosition = .camera(camera)
            }
        }
    }
    
    private func playSounds() {
        soundService.playingLoopCabinSound(named: "cabin_no_people")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.soundService.playBeltSound(named: "belt")
        }
    }
}
