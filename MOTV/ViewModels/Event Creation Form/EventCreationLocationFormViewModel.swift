//
//  EventCreationLocationFormViewModel.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-09-26.
//

import Foundation

import SwiftUI
import MapKit
import CoreLocation

class EventCreationLocationFormViewModel: NSObject, ObservableObject {
    
    @ObservedObject var locationServicesManager: LocationServices = LocationServices()
    
    @Published var searchText: String = ""
    @Published var searchResults: [MKPlacemark] = []
    
    // MAR
    
    // MARK: - Locations Search Query
    
    func searchQuery() {
        
        searchResults.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        if let region = locationServicesManager.region {
            request.region = region
        }
        
        MKLocalSearch(request: request).start { response, error in
        
            // Error checking and handling
            if let error = error { print("Location search error: \(error.localizedDescription)") }
            guard let searchResults = response else { return }
            
            // Publish search results
            
            self.searchResults = searchResults.mapItems.compactMap { mapItem in
                MKPlacemark(placemark: mapItem.placemark)
            }
            
        }
        
    }
    
}
