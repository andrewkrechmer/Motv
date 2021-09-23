//
//  UsersRepository.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-08-21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class UsersRepository: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var users = [User]()

    
    // -- Retreive Data
    
    func retreiveUser(with reference: DocumentReference, completion: @escaping (User) -> Void) { // TODO: - Restructure how Users are tracked. DocumentReference is too expensive, as only 1 document can be retreived per read to Firestore
            reference.getDocument { document, error in
                if let document = document {
                    do {
                        let newUser = try document.data(as: User.self)! // Forced unwrapped because option was check for with "if let document = document"
                        completion(newUser)
                    }
                    catch {
                        print(error)
                    }
                } else {
                    print("Error: Document doesn't exist")
                }
            }
        }
    
    }
    

