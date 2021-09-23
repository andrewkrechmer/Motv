//
//  EventRepository.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-08-18.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class EventRepository: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var events = [Event]()
    
    var testDataEvents: [Event] = [] // Test purposes array
    
    // -- Initializer
    
    init() {
        
        retreiveEvents()
        
        // MARK: - Write test events
        
//        // Define users
//        var testUser1 = User(id: "Rewey4UtqjURfMguLyJT", firstName: "Andrew", lastName: "Krechmer", birthDate: Date(timeIntervalSince1970: 1078030800), phoneNumber: 6135015082, directFriends: [])
//        var testUser2 = User(id: "6RIkpp52OPTsefjClJz8", firstName: "John", lastName: "Surette", birthDate: Date(timeIntervalSince1970: 1086926400), phoneNumber: 6137206629, directFriends: [])
//        var testUser3 = User(id: "RrIBj00u0sFpDPbzT8Hm", firstName: "Nial", lastName: "Potato", birthDate: Date(timeIntervalSince1970: 1088308800), phoneNumber: 6134070220, directFriends: [])
//        var testUser4 = User(id: "wVQkfuebrDeEchwpQLro", firstName: "Sam", lastName: "Arnprior", birthDate: Date(timeIntervalSince1970: 1083384000), phoneNumber: 6134076127, directFriends: [])
//        var testUser5 = User(id: "cO3QaVSRAgiv2omEBJ4i", firstName: "Kali", lastName: "Bettster", birthDate: Date(timeIntervalSince1970: 1081310400), phoneNumber: 6132555833, directFriends: [])
//
//        // Add friends for each user
//        testUser1.directFriends = [db.document("users/\(testUser2.id!)"), db.document("users/\(testUser3.id!)"), db.document("users/\(testUser4.id!)"), db.document("users/\(testUser5.id!)")]
//        testUser2.directFriends = [db.document("users/\(testUser1.id!)"), db.document("users/\(testUser3.id!)"), db.document("users/\(testUser5.id!)")]
//        testUser3.directFriends = [db.document("users/\(testUser1.id!)"), db.document("users/\(testUser2.id!)"), db.document("users/\(testUser5.id!)")]
//        testUser4.directFriends = [db.document("users/\(testUser1.id!)"), db.document("users/\(testUser5.id!)")]
//        testUser5.directFriends = [db.document("users/\(testUser1.id!)"), db.document("users/\(testUser2.id!)"), db.document("users/\(testUser3.id!)"), db.document("users/\(testUser4.id!)")]
//
//        // Fill arrays
//
//        testDataEvents = [
//            Event(draft: false, host: db.document("users/\(testUser1.id!)"), name: "Andrew's Party", start: 1630108800, end: 1630121400, location: Location(commonName: "Andrew's House", shortAddress: "58 Stonebriar Dr.", type: "House", latitude: 45.340197, longitude: -75.769407), activities: ["Hockey", "Football", "Basketball"], invitees: [db.document("users/\(testUser2.id!)"), db.document("users/\(testUser3.id!)"), db.document("users/\(testUser4.id!)"), db.document("users/\(testUser5.id!)")], confirmedAttendees: [db.document("users/\(testUser2.id!)"), db.document("users/\(testUser4.id!)")], minAttendees: 5, maxAttendees: 8, plusOnesAllowed: true),
//            Event(draft: false, host: db.document("users/\(testUser2.id!)"), name: "After School Hangout", start: 1630783800, end: 1630791000, location: Location(commonName: "Centrepointe", shortAddress: "260 Centrepointe Dr", type: "Park", latitude: 45.340272, longitude: -75.770435), activities: ["Chill out", "Eat food"], invitees: [db.document("users/\(testUser1.id!)"), db.document("users/\(testUser3.id!)"), db.document("users/\(testUser4.id!)"), db.document("users/\(testUser5.id!)")], confirmedAttendees: [db.document("users/\(testUser1.id!)")], minAttendees: 3, maxAttendees: 5, plusOnesAllowed: false)
//        ]
        
    }
    
    
    // -- Retreive Data
    
    func retreiveEvents() {
        db.collection("events")
            .getDocuments { querySnapshot, error in
                
                if let querySnapshot = querySnapshot {
                    
                    // Pull data from each document into an event variable, and add to an array (with no nil values)
                    
                    self.events = querySnapshot.documents.compactMap { document in
                    
                        do {
                            let event = try document.data(as: Event.self)
                            return event
                        }
                        catch {
                            print(error)
                        }
                        return nil
                    }
                }
            }
    }
    
    
    // -- Store Data
    
    func storeNewEvent(_ event: Event) {
        
        do {
            let _ = try db.collection("events").addDocument(from: event)
        }
        catch {
            fatalError("Unable to encode event: \(error.localizedDescription)")
        }
        
    }

    
/*    // -- Store New User
    
    func storeNewUser(_ user: User) {
        
        do {
            let _ = try db.collection("users").addDocument(from: user)
        }
        catch {
            fatalError("Unable to encode user: \(error.localizedDescription)")
        }
        
    } */
    
}
