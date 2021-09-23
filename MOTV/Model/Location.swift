//
//  Location.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-08-18.
//

import Foundation
import MapKit

struct Location: Codable {
    var commonName: String?
    var shortAddress: String // TODO: Turn into computed property
    var type: String?
    var latitude: Double
    var longitude: Double

}

enum LocationType {
    
}

