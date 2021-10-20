//
//  EventCreationFormViewModel.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-09-26.
//

import Foundation
import FirebaseFirestore

class EventCreationFormViewModel: ObservableObject {
    
    @Published var eventRepository: EventRepository
    
    @Published var eventName: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var location: SavedLocation = SavedLocation(commonName: "", addressString: "", latitude: 0, longitude: 0)
    
    @Published var invitees: [String] = []
    @Published var minimumAttendees: Int = 0
    @Published var maximumAttendees: Int = 35
    @Published var allowPlusOnes: Bool = false
    
    @Published var activities: [String] = []
    
    @Published var plusOnesAllowed: Bool = false
    
    init(eventRepository: EventRepository) {
        self.eventRepository = eventRepository
    }
    
    func postEvent() {
        
        var newEvent = Event(
            host: "",
            hostProfileImage: "",
            hostsRelationToEvent: .posted,
            eventName: eventName,
            start: startDate.timeIntervalSince1970,
            end: endDate.timeIntervalSince1970,
            location: location,
            activities: activities,
            invitees: invitees.map { EventInvitee(id: $0, profileImage: "", invitedBy: "", status: .invited) },
            minAttendees: minimumAttendees,
            maxAttendees: maximumAttendees,
            plusOnesAllowed: plusOnesAllowed
        )
        
        eventRepository.addNewEvent(&newEvent)
        
    }
    
}
