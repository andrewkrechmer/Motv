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
    @Published var userRepository: UsersRepository
    
    @Published var host: String = ""
    @Published var hostImage: String = ""
    
    @Published var eventName: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var location: SavedLocation = SavedLocation(commonName: "", addressString: "", latitude: 0, longitude: 0)
    
    @Published var invitees: [EventInvitee] = []
    @Published var minimumAttendees: Int = 0
    @Published var maximumAttendees: Int = 35
    @Published var allowPlusOnes: Bool = false
    
    @Published var activities: [String] = []
    @Published var textDetails: String = ""
    
    init(eventRepository: EventRepository, usersRepository: UsersRepository) {

        self.eventRepository = eventRepository
        
        self.userRepository = usersRepository
        
        retreiveHost()
        
    }
    
    func postEvent() {
        
        var newEvent = Event(
            host: host,
            hostProfileImage: hostImage,
            usersRelationToEvent: .posted,
            eventName: eventName,
            start: startDate.timeIntervalSince1970,
            end: endDate.timeIntervalSince1970,
            location: location,
            activities: activities,
            invitees: invitees,
            minAttendees: minimumAttendees,
            maxAttendees: maximumAttendees,
            plusOnesAllowed: allowPlusOnes,
            textDetails: ""
        )
        
        eventRepository.addNewEvent(&newEvent)
        
    }
    
    func retreiveHost() {
        
        userRepository.retreiveUser { user in
            
            self.host = user.id ?? ""
            
            self.hostImage = user.profileImage
            
        }
        
    }
    
}
