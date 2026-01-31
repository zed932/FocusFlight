//
//  GlobeBackgroundView.swift
//  FocusFlight
//
//  3D-глобус на заднем фоне. Центр — последнее приземление или домашний город.
//

import SwiftUI
import MapKit

/// Расстояние камеры для вида «глобус» (метры). ~18 000 км — видна кривизна Земли.
private let globeCameraDistance: Double = 18_000_000

/// Центр по умолчанию, если точка не задана (вид на Атлантику/Европу).
private let defaultCenter = CLLocationCoordinate2D(latitude: 25, longitude: 0)

struct GlobeBackgroundView: View {
    /// Координата центра глобуса (последнее приземление или домашний аэропорт). nil = вид по умолчанию.
    let center: CLLocationCoordinate2D?
    /// Размывать ли карту, чтобы не отвлекать от UI.
    let blurred: Bool

    @State private var cameraPosition: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: defaultCenter,
            distance: globeCameraDistance,
            heading: 0,
            pitch: 35
        )
    )

    init(center: CLLocationCoordinate2D? = nil, blurred: Bool = false) {
        self.center = center
        self.blurred = blurred
    }

    var body: some View {
        Map(position: $cameraPosition) {}
        .mapStyle(.imagery(elevation: .realistic))
        .mapControlVisibility(.hidden)
        .onAppear { updateCamera() }
        .blur(radius: blurred ? 12 : 0)
        .overlay(
            Color.black.opacity(blurred ? 0.35 : 0)
        )
        .ignoresSafeArea()
    }

    private func updateCamera() {
        let coord = center ?? defaultCenter
        cameraPosition = .camera(
            MapCamera(
                centerCoordinate: coord,
                distance: globeCameraDistance,
                heading: 0,
                pitch: 35
            )
        )
    }
}
