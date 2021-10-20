//
//  EventCreationSecondaryDetailsFormView.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-09-26.
//

import SwiftUI

struct EventCreationSecondaryDetailsForm: View {
    
    @ObservedObject var viewModel: EventCreationSecondaryDetailsFormViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var newActivityString: String = ""
    
    @State var backButtonActive: Bool = true;
    @State var searchFieldIsSelected: Bool = false;
    
    @Binding var presentEventCreationForm: Bool
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        EventCreationFormNavigationButtonView(active: $backButtonActive, text: "Friends")
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        EventCreationFormNavigationButtonView(active: $backButtonActive, text: "Save as Draft")
                    })
                    
                    Button(action: {
                        viewModel.eventCreationFormViewModel.postEvent()
                        presentEventCreationForm = false
                    }, label: {
                        EventCreationFormNavigationButtonView(active: $backButtonActive, text: "Post")
                    })
                    
                }
                .padding(.top, 0)
                .padding(.bottom, 12)
                
                ZStack {
                    TextField("Enter Activity", text: $newActivityString) { editing in
                        searchFieldIsSelected = editing
                    } onCommit: {
                        let newActivity = SecondaryInfo(text: newActivityString, type: .activity)
                        viewModel.eventCreationFormViewModel.activities.append(newActivity.text)
                        newActivityString = "";
                    }
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .fieldModifier($searchFieldIsSelected)
                    
                    HStack {
                        Spacer()
                        
                        if newActivityString.count > 1 {
                            Button(action: {
                                
                                hideKeyboard()
                                let newActivity = SecondaryInfo(text: newActivityString, type: .activity)
                                viewModel.eventCreationFormViewModel.activities.append(newActivity.text)
                                newActivityString = ""
                                
                            }, label: {
                                Image(systemName: "plus.circle")
                                    .padding(.trailing, 12)
                                    //.foregroundColor(MOTV_UI_BuildingApp.themeColor)
                            })
                        }
                        
                    }
                    
                }
                
                VStack(alignment: .center, spacing: 10) {
                    
                    ForEach(viewModel.eventCreationFormViewModel.activities, id: \.self) { activity in // MARK fix foreach id
                        SecondaryInfoCell(info: SecondaryInfo(text: activity, type: .activity))
                    }
                    
                }
                
                Spacer()
                
            }
            .navigationBarHidden(true)
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            
        }
        .navigationBarHidden(true)
        .onTapGesture {
            hideKeyboard()
        }
        
        
    }
}
struct EventCreationSecondaryDetailsFormView_Previews: PreviewProvider {
    static var previews: some View {
        
        Text("Event Creation Secondary Details Form Preview")
        
    }
}
