//
//  AuthenticationServices.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-10-04.
//

import Foundation

import Firebase
import FirebaseAuth

class AuthenticationServices: ObservableObject {
    
    var authenticationHandler: AuthStateDidChangeListenerHandle?
    
    @Published var signedIn: Bool = false
    @Published var auth: Auth?
    
    init() {
        authenticationHandler = Auth.auth().addStateDidChangeListener { auth, user in

            if user != nil {
                self.signedIn = true
                self.auth = auth
            }
            
        }

    }
    
    
    func signIn(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            guard result != nil else {
                print("Sign In Result is nil")
                return
            }
            
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    
    func signUp(email: String, password: String, completionHandler: @escaping (String) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            guard result != nil else {
                print("Sign In Result is nil")
                return
            }
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let uid = result?.user.uid {
                
                completionHandler(uid)
                
            }
            
        }
        
        
    }
    
}
