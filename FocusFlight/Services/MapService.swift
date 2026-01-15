//
//  MapService.swift
//  FocusFlight
//
//  Created by Сергей Мещеряков on 24.01.2026.
//

import MapKit
import Foundation
import _MapKit_SwiftUI

class MapService {
    
    static let shared = MapService()
    
    private init() {}
    
    // MARK: - Геопространственные вычисления
    
    /// Рассчитывает промежуточную точку на дуге большого круга
    func intermediatePoint(from: CLLocationCoordinate2D,
                          to: CLLocationCoordinate2D,
                          fraction: Double) -> CLLocationCoordinate2D {
        if fraction <= 0 { return from }
        if fraction >= 1 { return to }
        
        let lat1 = from.latitude.radians
        let lon1 = from.longitude.radians
        let lat2 = to.latitude.radians
        let lon2 = to.longitude.radians
        
        let angularDistance = acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(lon2 - lon1))
        let a = sin((1 - fraction) * angularDistance) / sin(angularDistance)
        let b = sin(fraction * angularDistance) / sin(angularDistance)
        
        let x = a * cos(lat1) * cos(lon1) + b * cos(lat2) * cos(lon2)
        let y = a * cos(lat1) * sin(lon1) + b * cos(lat2) * sin(lon2)
        let z = a * sin(lat1) + b * sin(lat2)
        
        let lat = atan2(z, sqrt(x * x + y * y))
        let lon = atan2(y, x)
        
        return CLLocationCoordinate2D(
            latitude: lat.degrees,
            longitude: lon.degrees
        )
    }
    
    /// Рассчитывает путь по дуге большого круга
    func calculateGreatCirclePath(from: CLLocationCoordinate2D,
                                  to: CLLocationCoordinate2D,
                                  steps: Int = 100) -> [CLLocationCoordinate2D] {
        var coordinates: [CLLocationCoordinate2D] = []
        
        for i in 0...steps {
            let fraction = Double(i) / Double(steps)
            coordinates.append(intermediatePoint(from: from, to: to, fraction: fraction))
        }
        
        return coordinates
    }
    
    /// Рассчитывает скорректированный азимут для иконки самолета
    func calculateCorrectedBearing(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let lat1 = from.latitude.radians
        let lon1 = from.longitude.radians
        let lat2 = to.latitude.radians
        let lon2 = to.longitude.radians
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let bearing = atan2(y, x)
        
        // Конвертируем радианы в градусы и корректируем для иконки самолета
        let bearingDegrees = bearing.degrees
        return bearingDegrees - 90
    }
    
    /// Рассчитывает азимут для камеры (без коррекции для иконки)
    func calculateCameraBearing(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let lat1 = from.latitude.radians
        let lon1 = from.longitude.radians
        let lat2 = to.latitude.radians
        let lon2 = to.longitude.radians
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let bearing = atan2(y, x)
        
        return bearing.degrees
    }
    
    /// Рассчитывает позицию камеры для обзорного режима
    func calculateOverviewCameraPosition(from: CLLocationCoordinate2D,
                                        to: CLLocationCoordinate2D) -> MapCamera {
        // Вычисляем середину маршрута
        let centerPoint = intermediatePoint(from: from, to: to, fraction: 0.5)
        
        // Вычисляем начальное направление для камеры
        let initialBearing = calculateCameraBearing(from: from, to: to)
        
        // Вычисляем оптимальную высоту для видимости всего маршрута
        let routeDistance = from.distance(to: to) * 1000
        let optimalDistance = max(routeDistance * 2.0, 1500000)
        
        return MapCamera(
            centerCoordinate: centerPoint,
            distance: optimalDistance,
            heading: initialBearing,
            pitch: 60
        )
    }
    
    /// Рассчитывает позицию камеры для режима следования
    func calculateFollowingCameraPosition(planePosition: CLLocationCoordinate2D,
                                          planeHeading: Double) -> MapCamera {
        // Для камеры нужно добавить 90° обратно, потому что самолет уже скорректирован
        let cameraHeading = planeHeading + 90
        
        return MapCamera(
            centerCoordinate: planePosition,
            distance: 400000,
            heading: cameraHeading,
            pitch: 45
        )
    }
}

// MARK: - Расширения для Double
extension Double {
    var radians: Double { self * .pi / 180 }
    var degrees: Double { self * 180 / .pi }
}
