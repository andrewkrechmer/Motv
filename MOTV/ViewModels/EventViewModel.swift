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
    @Published var userRepository = UsersRepository()
    //    private var cancellables = Set<AnyCancellable>()
    
    @Published var hostImage: UIImage = UIImage(systemName: "person")!
    @Published var nameText: String
    @Published var timeText: String = "Placeholder time"
    @Published var attendeesImages: [UIImage] = [UIImage(systemName: "person")!, UIImage(systemName: "person")!, UIImage(systemName: "person")!]
    @Published var attendeesText: String
    @Published var secondaryInfo: [(text: String, type: SecondaryInfo)]
    
    
    init(event: Event) {
        
        self.nameText = event.name
        
        self.attendeesText = "Joanna, Chad, Michael, Kylie, Thor, Guy, Borson, Dorra + 12 more"
        
        self.secondaryInfo = [(text: "Location", type: .Location)]
        
        self.timeText = timeText(for: event.start, to: event.end)
        
        userRepository.retreiveUser(with: event.host) { user in
            self.fetchImage(with: user.profileImageURL) {
                self.hostImage = $0
            }
        }
        
        determineAttendeeImages(for: event)
        
    }
    
    
    // MARK: - View Element Creating Functions
    
    // -- Fetch Image with URL
    private func fetchImage(with url: String, completion: @escaping (UIImage) -> Void) {
        
        //        if let image = CacheManager.shared.getFromCache(key: url) as? UIImage {
        //            completion(image)
        //        } else {
        
        if let url = URL(string: url) {
            
            let downloadTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                guard let imageData = data else { return }
                
                OperationQueue.main.addOperation {
                    guard let image = UIImage(data: imageData) else { return }
                    
                    completion(image)
                    
                    // Add the downloaded image to cache
                    // CacheManager.shared.cache(object: image, key: post.imageFileURL)
                    
                }
                
            })
            
            downloadTask.resume()
        }
        //        }
        
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
                date = Date(timeIntervalSince1970: start)
                timeText += dateFormatter.string(from: date)
            }
        }
        
        // --
        return timeText
        
    }
    
    // -- Determin attendeesText
    private func attendeesText(for event: Event) {
        
        
        
    }
    
    // -- Determine Attendees Images
    private func determineAttendeeImages(for event: Event) {
        
        var count = 0
        
        switch event.confirmedAttendees.count {
        
        case 0:
            break
            
        case 1:
            userRepository.retreiveUser(with: event.confirmedAttendees[0]) { user in
                self.fetchImage(with: user.profileImageURL) {
                    self.attendeesImages[0] = $0
                }
                count += 1
            }
            
        case 2:
            for i in 0...1 {
                userRepository.retreiveUser(with: event.confirmedAttendees[i]) { user in
                    self.fetchImage(with: user.profileImageURL) {
                        self.attendeesImages[i] = $0
                    }
                }
                count += 2
            }
            
        default:
            for i in 0...2 {
                userRepository.retreiveUser(with: event.confirmedAttendees[i]) { user in
                    self.fetchImage(with: user.profileImageURL) {
                        self.attendeesImages[i] = $0
                    }
                }
            }
            count += 3
            
        }
        
        switch event.invitees.count {
        
        case 0:
            break
            
        case 1:
            if count == 3 { break }
            userRepository.retreiveUser(with: event.invitees[0]) { user in
                self.fetchImage(with: user.profileImageURL) {
                    self.attendeesImages[0] = $0
                }
            }
            count += 1
            
        case 2:
            for i in 0...1 {
                if count == 3 { break }
                userRepository.retreiveUser(with: event.invitees[i]) { user in
                    self.fetchImage(with: user.profileImageURL) {
                        self.attendeesImages[i] = $0
                    }
                }
            }
            count += 2
            
        default:
            for i in 0...2 {
                if count == 3 { break }
                userRepository.retreiveUser(with: event.invitees[i]) { user in
                    self.fetchImage(with: user.profileImageURL) {
                        self.attendeesImages[i] = $0
                    }
                }
            }
            count += 3
        
        }
        
    }
    
    // -- Determine Secondary Info
//    private func secondaryInfo(for event: Event) -> [(text: String, type: SecondaryInfo)] {
//
//        // -
//        var info = [(text: String, type: SecondaryInfo)]()
//
//        // -
//        var locationText = "📍 "
//
//        if let locationName = event.location.commonName {
//            locationText += locationName
//        }
//        else {
//            locationText += event.location.shortAddress
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
        case Location
        case AttendeeLimit
        case PlusOnesPolicy
        case Activity
    }
    
}
