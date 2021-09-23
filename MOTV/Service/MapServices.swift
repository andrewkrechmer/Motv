//
//  MapServices.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-08-24.
//

import Foundation
import MapKit

class MapServices {
    
    // TODO: - Set up to work with publishers, until then this is useless
    
    static func expectedTravelTimeFromCurrentLocation(to destination: MKPlacemark, for transportType: MKDirectionsTransportType) -> Double? {
        
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
