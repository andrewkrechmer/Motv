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
    
    func retreiveUser(withUID uid: String, completion: @escaping (UserSecondModel) -> Void) {
        
        db.collection("users").document(uid)
            .addSnapshotListener { documentSnapshot, error in
                
                if let document = documentSnapshot {
                    do {
                        let retreivedUser = try document.data(as: UserSecondModel.self)! // Forced unwrapped because option was check for with "if let document = document"
                        completion(retreivedUser)
                        print(retreivedUser.profileImage)
                    }
                    catch {
                        print(error)
                    }
                } else {
                    print("Error: Document doesn't exist")
                }
                
            }
        
    }
    
    func retreiveUser(with reference: DocumentReference, completion: @escaping (User) -> Void) {
//            reference.getDocument { document, error in
//                if let document = document {
//                    do {
//                        let newUser = try document.data(as: User.self)! // Forced unwrapped because option was check for with "if let document = document"
//                        completion(newUser)
//                    }
//                    catch {
//                        print(error)
//                    }
//                } else {
//                    print("Error: Document doesn't exist")
//                }
//            }
        }
    
    
    // -- Create User
    
    func createUser(uid: String, firstName: String, lastName: String, profileImageData: Data) {
        
        db.collection("users").document(uid).setData(["firstName": firstName, "lastName": lastName, "profileImage": profileImageData])
        
    }
    
    }
    

