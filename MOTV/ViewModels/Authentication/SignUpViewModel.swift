//
//  SignUpViewModel.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-10-04.
//

import SwiftUI

class SignUpViewModel: ObservableObject {
    
    @ObservedObject var authenticationServices: AuthenticationServices
    @Published var userRepository: UsersRepository = UsersRepository()
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    
    @Published var imageName: String = ""
    
    func signUp() {
        authenticationServices.signUp(email: email, password: password) { uid in
            
            let image = UIImage(named: self.imageName)
            let data = image?.pngData()
            
            self.userRepository.createUser(uid: uid, firstName: self.firstName, lastName: self.lastName, profileImageData: data!)
        }
    }

    init(authenticationServices: AuthenticationServices) {
        self.authenticationServices = authenticationServices
    }
    
}
