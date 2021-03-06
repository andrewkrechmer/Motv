//
//  User.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-08-18.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Codable {

    @DocumentID var id: String? /*= UUID().uuidString*/
    
    var firstName: String
    var lastName: String
    
    var profileImageURL: String
    
    var birthDate: Date
    var age: Int {
        return 17
    }
    
    var phoneNumber: Int
    
    var directFriends: [String]
    // var mutualFriends: [DocumentReference]
    
}

struct UserSnapShot: Codable {
    
    @DocumentID var id: String? /*= UUID().uuidString*/
    
    var firstName: String
    var lastName: String
    
    var profileImage: String
    
}

struct UserSecondModel: Codable {
 
    @DocumentID var id: String?
    
    var email: String
    
    var firstName: String
    var lastName: String
    
    var profileImage: String
    
}
