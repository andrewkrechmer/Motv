//
//  EventViewModel.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-08-18.
//

import SwiftUI
import MapKit



class EventViewModel: ObservableObject, Identifiable {
    
    var specialColour = Color("Red") // Should be universal
    
    //    @Published var eventRepository = EventRepository()
    @Published var userRepository: UsersRepository
    //    private var cancellables = Set<AnyCancellable>()
    
    @Published var invitationBadge: (UsersRelationToEvent, String) = (.invited, "You're Invited")
    @Published var attendeeNumbersText: String = ""
    @Published var plusOnesAllowed: Bool = false
    @Published var hostImage: UIImage = UIImage(systemName: "person")!
    @Published var nameText: String = ""
    @Published var timeText: String = ""
    @Published var locationText: String = ""
    @Published var attendeesInfo: [Invitee] = []

    
    
    init(usersRepository: UsersRepository, event: Event) {
        
        self.userRepository = usersRepository
        
        self.nameText = event.eventName
        self.timeText = timeText(for: event.start, to: event.end)
        self.locationText = locationText(for: event.location)
        fetchHostImage(with: event.hostProfileImage)
        
        for i in 0..<8 {
            
            guard event.invitees.indices.contains(i) else { break }
            
            attendeesInfo.append(Invitee(name: event.invitees[i].firstName, profileImage: UIImage(systemName: "person") ?? UIImage(ciImage: CIImage(color: CIColor.white)), id: event.invitees[i].id))
            
            fetchAttendeesImages(for: event.invitees, count: attendeesInfo.count)
            
        }
        
        self.plusOnesAllowed = event.plusOnesAllowed
        
    }
    
    struct Invitee: Hashable, Identifiable {
        var name: String
        var profileImage: UIImage
        var id: String
    }
    
    
    // MARK: - View Element Creating Functions
    
    private func locationText(for location: SavedLocation) -> String {
        if location.commonName == "" { return location.addressString } else { return location.commonName }
    }
    
    // Fetch Images
    
    private func fetchHostImage(with url: String) {
        let imageFetcher = ImageFetcher()
        imageFetcher.fetchImage(with: url) { image in
            self.hostImage = image
        }
    }
    
    private func fetchAttendeesImages(for invitees: [EventInvitee], count: Int) {
        for i in 0..<count {
            let imageFetcher = ImageFetcher()
            imageFetcher.fetchImage(with: invitees[i].profileImage) { image in
                self.attendeesInfo[i].profileImage = image
            }
        }
    }
    
    // -- Determine Time Text
    private func timeText(for start: TimeInterval, to end: TimeInterval?) -> String { // TODO: - Make continously update time asynchroniously
        
        // --
        var timeText: String
        var date: Date
        let dateFormatter = DateFormatter()
        
        var timeTextIsComplete = false
        
        let timeToStart = start - Date().timeIntervalSince1970
        
        // --
        switch timeToStart {
        
        case ..<(-180): // Event has been going for more than 3 minutes
            date = Date(timeIntervalSinceNow: -timeToStart)
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("hmmss")
            timeText = "Ongoing | \(dateFormatter.string(from: date))"
            timeTextIsComplete = true
            
        case -180..<0:
            timeText = "Starts Now"
            timeTextIsComplete = true
            
        case 0..<7200:
            date = Date(timeIntervalSinceNow: timeToStart)
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("hmmss")
            timeText = "Starts in \(dateFormatter.string(from: date))"
            timeTextIsComplete = true
            
        case 7200..<86400:
            timeText = "Today | "
            
        case 86400..<172800:
            timeText = "Tomorrow | "
            
        case 172800..<518400:
            date = Date(timeIntervalSince1970: start)
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
            timeText = "\(dateFormatter.string(from: date)) | "
            
        default:
            date = Date(timeIntervalSince1970: start)
            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMd")
            timeText = "\(dateFormatter.string(from: date)) | "
            
        }
        
        // --
        if !timeTextIsComplete {
            
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            
            if let end = end {
                date = Date(timeIntervalSince1970: start)
                timeText += "\(dateFormatter.string(from: date)) to "
                date = Date(timeIntervalSince1970: end)
                timeText += dateFormatter.string(from: date)
            } else {
                date = Date(timeIntervalSinceNow: start)
                timeText += dateFormatter.string(from: date)
            }
        }
        
        // --
        return timeText
        
    }
    
    
    // -- Determine Secondary Info
//    private func secondaryInfo(for event: Event) -> [(text: String, type: SecondaryInfo)] {
//
//        // -
//        var info = [(text: String, type: SecondaryInfo)]()
//
//        // -
//        var Text = "📍 "
//
//        if let Name = event..commonName {
//            Text += Name
//        }
//        else {
//            Text += event..shortAddress
//        }
//
//        if let mapTime
//
//        // -
//        return info
//
//    }
    
    
    
    
    // MARK: -
    
    enum SecondaryInfo {
        case location
        case AttendeeLimit
        case PlusOnesPolicy
        case Activity
    }
    
}

