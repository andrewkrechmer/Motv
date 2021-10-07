//
//  AuthenticationView.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-10-02.
//

import SwiftUI

struct SignUpView: View {

    @ObservedObject var viewModel: SignUpViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var emailFieldIsSelected: Bool = false
    @State var passwordFieldIsSelected: Bool = false
    @State var firstNameFieldIsSelected: Bool = false
    @State var lastNameFieldIsSelected: Bool = false
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            TextField("Email", text: $viewModel.email)
                .fieldModifier($emailFieldIsSelected)
            
            SecureField("Password", text: $viewModel.password)
                .fieldModifier($passwordFieldIsSelected)
            
            TextField("First Name", text: $viewModel.firstName)
                .fieldModifier($firstNameFieldIsSelected)
            
            TextField("Last Name", text: $viewModel.lastName)
                .fieldModifier($lastNameFieldIsSelected)
            
            TextField("Image Name", text: $viewModel.imageName)
                .fieldModifier($lastNameFieldIsSelected)
            
            Spacer()
            
            Button {
                viewModel.signUp()
                //self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Sign Up")
                    .font(FontManager(typeFace: .GTAmericaExtendedBoldItalic, size: 12).requestedFont)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 6)
                    .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.primary).opacity(0.1).background(RoundedRectangle(cornerRadius: 15).strokeBorder(lineWidth: 1)))
            }
            
        }.padding(30)
        
    }
    
}

struct SignInView: View {
    
    @ObservedObject var viewModel: SignInViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack {
            
            TextField("Email", text: $viewModel.email)
            
            SecureField("Password", text: $viewModel.password)
            
            Spacer()
            
            Button {
                viewModel.signIn()
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Sign In")
            }
            
        }.padding(30)
        
    }
    
}

//struct AuthenticationView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView(viewModel: SignUpViewModel())
//    }
//}
