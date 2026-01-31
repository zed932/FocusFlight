//
//  GeoExtensions.swift
//  FocusFlight
//
//  Гео-расчёты: расстояние между координатами (гаверсинусы) и конвертация углов.
//

import CoreLocation

extension CLLocationCoordinate2D {
    /// Расстояние до другой точки по поверхности Земли (км), формула гаверсинусов.
    func distance(to other: CLLocationCoordinate2D) -> Double {
        let earthRadiusKm = 6371.0
        let dLat = (other.latitude - latitude).degreesToRadians
        let dLon = (other.longitude - longitude).degreesToRadians
        let lat1 = latitude.degreesToRadians
        let lat2 = other.latitude.degreesToRadians
        let a = sin(dLat/2) * sin(dLat/2) +
                sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        return earthRadiusKm * c
    }
}

extension Double {
    var degreesToRadians: Double { self * .pi / 180 }
    var radians: Double { degreesToRadians }
    var degrees: Double { self * 180 / .pi }
}
