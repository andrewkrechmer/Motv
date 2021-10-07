//
//  SignInViewModel.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-10-04.
//

import SwiftUI

class SignInViewModel: ObservableObject {
    
    @ObservedObject var authenticationServices: AuthenticationServices
    
    @Published var isSignedIn: Bool = false
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    
    func signIn() {
        authenticationServices.signIn(email: email, password: password)
    }
    
    init(authenticationServices: AuthenticationServices) {
        self.authenticationServices = authenticationServices
    }
    
}
