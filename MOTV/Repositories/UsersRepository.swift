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
    
    @Published var friends = [UserSnapShot]()
    
   private var lastRetreivedDocument: DocumentSnapshot?
    
    // -- Retreive Friends
    
    func retreiveFriends(batchSize: Int) {
        
        //let currentUserId: String = Auth.auth().currentUser?.uid ?? ""
        
        let friendsQuery = db.collection("users")/*.document(currentUserId).collection("friends")*/
            .limit(to: batchSize)
        
        if let lastRetreivedDocument = lastRetreivedDocument {
            friendsQuery
                .start(afterDocument: lastRetreivedDocument)
        }
        
        friendsQuery
            .getDocuments { querysnapshot, error in
                
                if let snapshot = querysnapshot {
                    
                    self.lastRetreivedDocument = snapshot.documents.last
                    
                    self.friends = snapshot.documents.compactMap { document in
                        
                        do {
                            let friend = try document.data(as: UserSnapShot.self)
                            return friend
                        }
                        catch {
                            print("error retreving friends: \(error)")
                            return nil
                        }
                        
                    }
                    
                }
            }
    }
    
    // -- Retreive User
    
    func retreiveUser(completion: @escaping (UserSecondModel) -> Void) {
        
        let currentUserId: String = Auth.auth().currentUser?.uid ?? ""
        
        db.collection("users").document(currentUserId)
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
    

