//
//  FlightMapView.swift
//  FocusFlight
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
            if let fromCoord = flight.fromAirport.coordinate {
                Annotation(flight.fromAirport.name, coordinate: fromCoord) {
                    AirportAnnotationView(systemName: "airplane.departure", color: .green)
                }
                .annotationTitles(.hidden)
            }
            if let toCoord = flight.toAirport.coordinate {
                Annotation(flight.toAirport.name, coordinate: toCoord) {
                    AirportAnnotationView(systemName: "airplane.arrival", color: .blue)
                }
                .annotationTitles(.hidden)
            }

            Annotation("✈️", coordinate: currentPlanePosition) {
                PlaneView(heading: planeHeading)
            }
            .annotationTitles(.hidden)

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
