//
//  FlightView.swift 
//  FocusFlight
//
//  Created by Сергей Мещеряков on 15.01.2026.
//

import SwiftUI
import MapKit

struct FlightView: View {
    let flight: Flight
    @Binding var path: [Screen]
    
    @StateObject private var viewModel: FlightViewModel
    
    init(flight: Flight, path: Binding<[Screen]>) {
        self.flight = flight
        self._path = path
        self._viewModel = StateObject(wrappedValue: FlightViewModel(flight: flight))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Основная карта
                FlightMapView(
                    flight: flight,
                    cameraPosition: $viewModel.cameraPosition,
                    mapStyle: $viewModel.mapStyle,
                    planeHeading: viewModel.planeHeading,
                    greatCirclePath: viewModel.greatCirclePath,
                    currentPlanePosition: viewModel.currentPlanePosition
                )
                
                // Overlay элементы
                VStack {
                    // Верхняя панель
                    HStack {
                        Spacer()
                        CameraModeButton(
                            mode: viewModel.cameraMode,
                            action: viewModel.toggleCameraMode
                        )
                        .padding(.top, geometry.safeAreaInsets.top + 10)
                        .padding(.trailing, 20)
                    }
                    
                    Spacer()
                    
                    // Нижние метрики
                    FlightMetricsView(
                        remainingTime: viewModel.timerService.remainingTime,
                        remainingDistance: viewModel.remainingDistance
                    )
                    .padding(.bottom, max(50, geometry.safeAreaInsets.bottom + 20))
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
        .onChange(of: viewModel.timerService.remainingTime) { newValue in
            if newValue <= 0 {
                viewModel.timerService.stopTimer()
                viewModel.soundService.playBeltSound(named: "belt")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    path.append(.LandedView(flight))
                }
            }
        }
    }
}
