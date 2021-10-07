//
//  Event.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-08-18.
//

import SwiftUI
import MapKit

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Event: Codable, Identifiable {
    
    @DocumentID var id: String? /*= UUID().uuidString*/
    
    var draft: Bool
    
    var host: DocumentReference
    var name: String
    
    var start: TimeInterval
    var end: TimeInterval?
    var location: SavedLocation
    var activities: [String]
    
    var invitees: [DocumentReference]
    var confirmedAttendees: [DocumentReference]
    var minAttendees: Int
    var maxAttendees: Int
    var plusOnesAllowed: Bool
    
    // -- Initializer
    
    init(draft: Bool, host: DocumentReference, name: String, start: TimeInterval, end: TimeInterval?, location: SavedLocation, activities: [String], invitees: [DocumentReference], confirmedAttendees: [DocumentReference], minAttendees: Int, maxAttendees: Int, plusOnesAllowed: Bool) {
        
        self.draft = draft
        self.host = host
        self.name = name
        self.start = start
        self.end = end
        self.location = location
        self.activities = activities
        self.invitees = invitees
        self.confirmedAttendees = confirmedAttendees
        self.minAttendees = minAttendees
        self.maxAttendees = maxAttendees
        self.plusOnesAllowed = plusOnesAllowed
        
    }
        
}

struct SecondaryInfo: Identifiable {
    var text: String
    var type: SecondaryInfoType
    var id = UUID().uuidString
}

enum SecondaryInfoType {
    
    case location
    case attendeeLimit
    case plusOnePolicy
    case activity
    
    func cellColor() -> Color {
        switch self {
        case .location:
            return Color.yellow
        default:
            return Color.white
        }
    }
}

