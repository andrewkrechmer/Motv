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
    }
    
    
    // -- Retreive Data
    
    func retreiveEvents() {
        
       let currentUserId: String = Auth.auth().currentUser?.uid ?? ""
        
        db.collection("users").document(currentUserId).collection("events")
            .addSnapshotListener { querySnapshot, error in
                
                if let querySnapshot = querySnapshot {
                    
                    // Pull data from each document into an event variable, and add to an array (with no nil values)
                    
                    self.events = querySnapshot.documents.compactMap { document in
                    
                        do {
                            let event = try document.data(as: Event.self)
                            return event
                        }
                        catch {
                            print(error.localizedDescription)
                        }
                        return nil
                    }
                }
            }
    }
    
    
    // -- Store Data
    
    func addNewEvent(_ event: inout Event) {
        
        let currentUserId: String = Auth.auth().currentUser?.uid ?? ""
        
        event.host = currentUserId
        
        do {
            let _ = try db.collection("users").document(currentUserId).collection("events").addDocument(from: event)
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
