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
    
    private var lastRetreivedDocument: DocumentSnapshot?
    
    // -- Retreive Friends
    
    func retreiveFriends(batchSize: Int, completion: @escaping ([UserSnapShot])->Void) {
        
        //let currentUserId: String = Auth.auth().currentUser?.uid ?? ""
        
        let friendsQuery = db.collection("users")/*.document(currentUserId).collection("friends")*/
      //      .order(by: "firstName")
        
        if let lastRetreivedDocument = lastRetreivedDocument {
            
            // Second query and on
            
            friendsQuery
                .start(afterDocument: lastRetreivedDocument)
                .limit(to: 5)
                .getDocuments { querysnapshot, error in
                    
                    if let snapshot = querysnapshot {
                        
                        guard let _ = snapshot.documents.last else {
                            // The collection is empty.
                            return
                        }
                        
                        self.lastRetreivedDocument = snapshot.documents.last
                        
                        let friends: [UserSnapShot] = snapshot.documents.compactMap { document in
                            
                            do {
                                let friend = try document.data(as: UserSnapShot.self)
                                return friend
                            }
                            catch {
                                print("error retreving friends: \(error)")
                                return nil
                            }
                            
                        }
                        
                        completion(friends)
                        
                    }
                }
        }
        else { // First query
            
            friendsQuery
                .limit(to: 5)
                .getDocuments { querysnapshot, error in
                    
                    if let snapshot = querysnapshot {
                        
                        guard let _ = snapshot.documents.last else {
                            // The collection is empty.
                            return
                        }
                        
                        self.lastRetreivedDocument = snapshot.documents.last
                        
                        let friends: [UserSnapShot] = snapshot.documents.compactMap { document in
                            
                            do {
                                let friend = try document.data(as: UserSnapShot.self)
                                return friend
                            }
                            catch {
                                print("error retreving friends: \(error)")
                                return nil
                            }
                            
                        }
                        
                        completion(friends)
                        
                    }
                }
            
        }


    }
    
    func d(_ arr: [UserSnapShot]) {
        for user in arr { print(user.firstName + user.lastName) }
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
    
    
    // -- Create User
    
    func createUser(uid: String, firstName: String, lastName: String, profileImageData: Data) {
        
        db.collection("users").document(uid).setData(["firstName": firstName, "lastName": lastName, "profileImage": profileImageData])
        
    }
    
    }
    

