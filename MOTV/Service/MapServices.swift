//
//  MapServices.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-08-24.
//

import Foundation
import MapKit
import CoreLocation

// MARK: - LocationServices (From UI Building)

final class LocationServices: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    private let locationManager = CLLocationManager()
    
    var authorizationStatus: CLAuthorizationStatus = .restricted
    
    @Published var region: MKCoordinateRegion?
    var regionLatitudeBounds: Double?
    var regionLongitudeBounds: Double?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    
    // -- Permission changed
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
        
        case .denied:
            self.authorizationStatus = .denied
            
        case .notDetermined:
            self.authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse:
            self.authorizationStatus = .authorizedWhenInUse
            manager.requestLocation()
            
        case .authorizedAlways:
            self.authorizationStatus = .authorizedAlways
            manager.requestLocation()
        
        default:
            ()
        
        }
        
    }
    
    
    // -- Error
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Location Manager Error: \(error.localizedDescription)")
        
    }
    
    
    // -- Getting the users region
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: self.regionLatitudeBounds ?? 10000, longitudinalMeters: self.regionLongitudeBounds ?? 10000)
        
    }
    
}


// MARK: - Map Services (Old)

class MapServices {
    
    // TODO: - Set up to work with publishers, until then this is useless
    
    static func expectedTravelTimeFromCurrent(to destination: MKPlacemark, for transportType: MKDirectionsTransportType) -> Double? {
        
        var expectedTravelTime: Double?
        
        // - Set up direction request
        let request = MKDirections.Request()
        
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(placemark: destination)
        
        request.transportType = transportType
        
        // - Get directions
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            
            guard let response = response else {
                if let error = error {
                    print("Error getting directions: \(error)")
                }
                return
            }
            
            expectedTravelTime = response.routes[0].expectedTravelTime
        }
        
        return expectedTravelTime
        
    }
    
}
