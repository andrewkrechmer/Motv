//
//  EventCreationFormViewModel.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-09-26.
//

import Foundation
import FirebaseFirestore

class EventCreationFormViewModel: ObservableObject {
    
    @Published var eventRepository = EventRepository()
    
    @Published var eventName: String = "Test Test"
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var location: SavedLocation = SavedLocation(commonName: "", addressString: "", latitude: 0, longitude: 0)
    
    @Published var invitees: [DocumentReference] = []
    @Published var minimumAttendees: Int = 0
    @Published var maximumAttendees: Int = 35
    @Published var allowPlusOnes: Bool = false
    
    @Published var activities: [SecondaryInfo] = []
    
    func postEvent() {
        let newEvent = Event(draft: false, host: eventRepository.db.collection("users").document("6RIkpp52OPTsefjClJz8"), name: eventName, start: startDate.timeIntervalSince1970, end: endDate.timeIntervalSince1970, location: location, activities: ["Implement", "Activities", "Back", "End"], invitees: invitees, confirmedAttendees: [], minAttendees: minimumAttendees, maxAttendees: maximumAttendees, plusOnesAllowed: allowPlusOnes)
        
        eventRepository.addNewEvent(newEvent)
        
    }
    
}
