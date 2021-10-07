//
//  PersonalProfileViewModel.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-10-06.
//

import Foundation
import SwiftUI


class PersonalProfileViewModel: ObservableObject {
    
    @Published var userRepository: UsersRepository
    
    @Published var profileImage: UIImage
    
    @Published var firstName: String
    
    @Published var lastName: String
    
    init(uid: String) {
        
        self.profileImage = UIImage(systemName: "person")!
        self.firstName = ""
        self.lastName = ""
        
        self.userRepository = UsersRepository()
        
        self.retreiveUser(withUID: uid)
        
    }
    
    func retreiveUser(withUID uid: String) {
        
        userRepository.retreiveUser(withUID: uid) { user in
            
            self.firstName = user.firstName
            
            self.lastName = user.lastName
            
            self.profileImage = UIImage(data: user.profileImage) ?? UIImage(systemName: "person")!
            
        }
        
    }
    
}
