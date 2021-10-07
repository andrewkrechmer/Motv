//
//  EventCreationPrimaryDetailsFormView.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-09-26.
//

import SwiftUI
import UIKit
import MapKit


struct EventCreationPrimaryDetailsFormView: View {
    
    @EnvironmentObject var viewModel: EventCreationPrimaryDetailsFormViewModel
    
    @State var includeEndDate = true
    
    @State var eventNameFieldIsSelected: Bool = false
    @State var locationFieldIsSelected: Bool = false
    @State var locationFieldIsActive: Bool = false
    
    @Binding var presentEventCreationForm: Bool
    
    let dateFormatter = DateFormatter()
    init(presentEventCreationForm: Binding<Bool>) {
        
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        
        self._presentEventCreationForm = presentEventCreationForm
    }

    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .leading, spacing: 15) {
                
                HStack() {
                    Spacer()
                    NavigationLink(
                        destination: EventCreationInviteesFormView(presentEventCreationForm: $presentEventCreationForm),
                        label: {
                            EventCreationFormNavigationButtonView(active: $viewModel.formIsValid, text: "Friends")
                        })
                        //.disabled(!viewModel.formIsValid)
                }
                .padding(.top, 12)
                .padding(.bottom, 12)
                
                // ---- Event name text field
                
                TextField("Event Name", text: $viewModel.eventName) { editing in
                    eventNameFieldIsSelected = editing
                } onCommit: {
                   
                }
                .font(.system(size: 16, weight: .medium, design: .default))
                .fieldModifier($eventNameFieldIsSelected)
                .onChange(of: viewModel.eventName) { value in }
                .padding(.bottom, 6)
                
                
                // ---- Start date and time fields
                
                DatePicker("Starts", selection: $viewModel.startDate, in: Date()...Date(timeIntervalSinceNow: 31536000), displayedComponents: [ .hourAndMinute, .date])
                    .datePickerStyle(DefaultDatePickerStyle())
                    .padding(.horizontal, 12)
                    
                    
                // ---- End date and time fields
                
                
                if includeEndDate {
                    DatePicker("Ends", selection: $viewModel.endDate, in: Date()...Date(timeIntervalSinceNow: 31536000), displayedComponents: [ .hourAndMinute, .date])
                        .datePickerStyle(DefaultDatePickerStyle())
                        .padding(.horizontal, 12)
                }
                
                
                // ---- Include end date toggle
                
                Divider()
                    .padding(.top, 6)
                
                HStack(alignment: .center) {
                    Text("Include End Date")
                    .font(.system(size: 16, weight: .medium, design: .default))

                    Toggle("", isOn: $includeEndDate)
        //                .accentColor(MOTV_UI_BuildingApp.themeColor)
                }
                .padding(.horizontal, 12)
                
                Divider()
        
                
                Button {
                    locationFieldIsSelected.toggle()
                    locationFieldIsActive = true
                } label: {
                    ZStack {
                        
                        Text(viewModel.location.commonName)
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .foregroundColor(locationFieldIsActive ? .primary : Color(UIColor.systemGray3))
                            .fieldModifier($locationFieldIsSelected)
                        

                        HStack {
                            Spacer()
                            Image(systemName: "location")
                                .padding(.trailing, 12)
         //                       .foregroundColor(MOTV_UI_BuildingApp.themeColor)
                        }
                    }
                }
                
                
                Spacer()
            }
            .padding(.horizontal, 20.0)
            .navigationBarHidden(true)
            
        }
       .background(Color.backGroundColor)
        .onTapGesture {
            hideKeyboard()
        }
        .sheet(isPresented: $locationFieldIsSelected) {
            EventCreationLocationFormView(mapModel: EventCreationLocationFormViewModel(), savedLocations: TestData.testSavedLocations, locationSelection: $viewModel.location)
        }
        
    }
    
}

struct  EventCreationFormNavigationButtonView: View {
    
    @Binding var active: Bool
    var text: String
    
    var body: some View {
        
        Text(text)
            .font(FontManager(typeFace: .GTAmericaExtendedBoldItalic, size: 12).requestedFont)
            .foregroundColor(.primary)
            .padding(.horizontal, 18)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.primary).opacity(0.1)
                    .background(RoundedRectangle(cornerRadius: 15).strokeBorder(lineWidth: 1)/*.foregroundColor(MOTV_UI_BuildingApp.themeColor).opacity(0.9)*/)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(!active ? Color(UIColor.systemGray6).opacity(0.7) : .clear)
            )
    }
    
}

struct FieldModifier: ViewModifier {
    
    @Binding var fieldIsSelected: Bool
    
    func body(content: Content) -> some View {
        
        content
            .frame(width: 350, height: 25, alignment: .leading)
            .keyboardType(.default)
            .autocapitalization(.words)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(FormFieldBackground(isSelected: $fieldIsSelected))
            
        
    }
    
}

struct FormFieldBackground: View {
    
    @Binding var isSelected: Bool
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.backGroundColor)
            .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(/*isSelected ? MOTV_UI_BuildingApp.themeColor. :*/ .black, lineWidth: 1)
            )
    }
}

extension View {
    
    func fieldModifier(_ isSelected: Binding<Bool>) -> some View {
        modifier(FieldModifier(fieldIsSelected: isSelected))
    }
    
}

extension View {
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func becomeFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
    }
    
}


struct EventCreationPrimaryDetailsFormView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Text("Event Creation Primary Details Form Preview")
    
    }
}
