//
//  PersonalProfileViewModel.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-10-06.
//

import Foundation
import SwiftUI


class PersonalProfileViewModel: ObservableObject {
    
    @Published var usersRepository: UsersRepository
    
    @Published var profileImage: UIImage
    
    @Published var firstName: String
    
    @Published var lastName: String
    
    init(usersRepository: UsersRepository) {
        
        self.profileImage = UIImage(systemName: "person")!
        self.firstName = ""
        self.lastName = ""
        
        self.usersRepository = usersRepository
        
        self.retreiveCurrentUser()
        
    }
    
    func retreiveCurrentUser() {
        
        usersRepository.retreiveUser() { user in
            
            self.firstName = user.firstName
            
            self.lastName = user.lastName
            
            self.profileImage = UIImage(systemName: "person")!
            
            let imageFetcher = ImageFetcher()
            imageFetcher.fetchImage(with: user.profileImage) { image in
                self.profileImage = image
            }
        }
        
    }
    
}
