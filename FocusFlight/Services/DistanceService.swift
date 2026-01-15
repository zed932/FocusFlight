


import CoreLocation


import CoreLocation

extension CLLocationCoordinate2D {
    func distance(to: CLLocationCoordinate2D) -> Double {
        let earthRadiusKm = 6371.0
        
        let dLat = (to.latitude - self.latitude).degreesToRadians
        let dLon = (to.longitude - self.longitude).degreesToRadians
        
        let lat1 = self.latitude.degreesToRadians
        let lat2 = to.latitude.degreesToRadians
        
        let a = sin(dLat/2) * sin(dLat/2) +
                sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        
        return earthRadiusKm * c
    }
}

extension Double {
    var degreesToRadians: Double { return self * .pi / 180 }
}
