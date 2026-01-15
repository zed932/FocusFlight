


//{
//  "id": 4650,
//  "ident": "03N",
//  "name": "Utirik Airport",
//  "latitude_deg": "11.222219",
//  "longitude_deg": "169.851429",
//  "elevation_ft": 4,
//  "continent": "OC",
//  "iso_country": "MH",
//  "iso_region": "MH-UTI",
//  "municipality": "Utirik Island",
//  "iata_code": "UTK"
//},

import CoreLocation
import Foundation

struct Airport: Codable, Identifiable, Hashable {
    let id: Int
    let ident: String
    let name: String
    let latitude_deg: String?
    let longitude_deg: String?
    let elevation_ft: Int?
    let continent: String
    let iso_country: String
    let iso_region: String
    let municipality: String
    let iata_code: String
    
    var latitudeDouble: Double? {
        guard let lat = latitude_deg else { return nil }
        return Double(lat)
    }
    
    var longitudeDouble: Double? {
        guard let lon = longitude_deg else { return nil }
        return Double(lon)
    }
    
    var coordinate: CLLocationCoordinate2D? {
        guard let lat = latitudeDouble, let lon = longitudeDouble else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
