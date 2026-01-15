//
//  MapView.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 24.01.2026.
//

import SwiftUI
import MapKit

struct FlightMapView: View {
    let flight: Flight
    @Binding var cameraPosition: MapCameraPosition
    @Binding var mapStyle: MapStyle
    let planeHeading: Double
    let greatCirclePath: [CLLocationCoordinate2D]
    let currentPlanePosition: CLLocationCoordinate2D
    
    var body: some View {
        Map(position: $cameraPosition) {
            // Аэропорт отправления
            Annotation(flight.fromAirport.name, coordinate: flight.fromAirport.coordinate!) {
                AirportAnnotationView(systemName: "airplane.departure", color: .green)
            }
            .annotationTitles(.hidden)
            
            // Аэропорт назначения
            Annotation(flight.toAirport.name, coordinate: flight.toAirport.coordinate!) {
                AirportAnnotationView(systemName: "airplane.arrival", color: .blue)
            }
            .annotationTitles(.hidden)
            
            // Самолет (анимированный)
            Annotation("✈️", coordinate: currentPlanePosition) {
                PlaneView(heading: planeHeading)
            }
            .annotationTitles(.hidden)
            
            // Маршрут (дуга большого круга)
            if !greatCirclePath.isEmpty {
                MapPolyline(
                    coordinates: greatCirclePath,
                    contourStyle: .geodesic
                )
                .stroke(.blue.opacity(0.7), lineWidth: 2)
            }
        }
        .mapStyle(mapStyle)
        .ignoresSafeArea()
    }
}
