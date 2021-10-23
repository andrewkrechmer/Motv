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
    
    @DocumentID var id: String?
    
    var host: String
    
    var hostProfileImage: String
    
    var usersRelationToEvent: UsersRelationToEvent
    
    var eventName: String
    
    var start: TimeInterval
    
    var end: TimeInterval?
    
    var location: SavedLocation
    
    var activities: [String]
    
    var invitees: [EventInvitee]
    
    var minAttendees: Int
    
    var maxAttendees: Int
    
    var plusOnesAllowed: Bool
    
    var textDetails: String
        
}

struct EventInvitee: Codable, Identifiable, Equatable {
    var id: String
    var profileImage: String
    var firstName: String
    var lastName: String
    var invitedBy: String
    var status: UsersRelationToEvent
}

enum UsersRelationToEvent: String, Codable {
    
    case drafted
    case posted
    
    case invited
    case saved
    case accepted
    case declined
    
    case hosted
    case attended
    case missed
    
}





// Belongs Elsewhere

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


