//
//  TestUserSwitcher.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-10-08.
//

import SwiftUI

struct TestUserSwitcher: View {
    
    @ObservedObject var authServices: AuthenticationServices
    @ObservedObject var repo: UsersRepository
    
    @State var users = [UserSecondModel]()
    
    
    var body: some View {
    
        Text("Choose User")
            .onAppear {
                
                repo.db.collection("users")
                    .getDocuments { querySnapshot, error in
                        
                        if let querySnapshot = querySnapshot {
                            
                            self.users = querySnapshot.documents.compactMap { document in
                            
                                do {
                                    let user = try document.data(as: UserSecondModel.self)
                                    return user
                                }
                                catch {
                                    print(error.localizedDescription)
                                }
                                return nil
                            }
                        }
                        
                    }
            }
        
        ForEach(users, id: \.id) { user in

            UserButton(name: "\(user.firstName) \(user.lastName)", profileImageData: user.profileImage) {
                
                //authServices.signOut()
                
                authServices.signIn(email: user.email, password: "havXef-tebbi7-tubguq")
                
            }

        }
        
    }
    
}

struct UserButton: View {
    
    var name: String
    var profileImageData: Data
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(uiImage: UIImage(data: profileImageData)!)
            Text(name)
        }
    }
}
