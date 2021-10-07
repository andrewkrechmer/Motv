//
//  .swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-08-18.
//

import Foundation
import MapKit
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SavedLocation: Codable, Identifiable, Equatable {
    
    var commonName: String
    var addressString: String
   // var type: String?

    var latitude: Double
    var longitude: Double
    @DocumentID var id = UUID().uuidString
    
}
enum Type {
    
}

