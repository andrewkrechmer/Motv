//
//  PersonalProfileView.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-10-06.
//

import SwiftUI

struct PersonalProfileView: View {
    
    @EnvironmentObject var viewModel: PersonalProfileViewModel
    
    var body: some View {
        
        VStack {
            
            Image(uiImage: viewModel.profileImage)
            
            Text(viewModel.firstName + " " + viewModel.lastName)
            
        }
        
    }
}

//struct PersonalProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        PersonalProfileView(viewModel: PersonalProfileViewModel())
//    }
//}
