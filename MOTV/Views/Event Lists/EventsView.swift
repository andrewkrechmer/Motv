//
//  ContentView.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-08-18.
//

// Unseen invitations, seen invitation (re-targeted), saved invitations

import SwiftUI
import CoreData

import Firebase
import FirebaseAuth

struct EventsView: View {
    
    @ObservedObject var eventsViewModel: EventsViewModel
    
    @EnvironmentObject var testAuth: AuthenticationServices
    
    @State var presentEventCreationForm: Bool = false
    
    var body: some View {

        NavigationView {
            
            ZStack {
                
                ScrollView(.vertical, showsIndicators: false) { // Events Scroll View
                    
                    LazyVStack(alignment: .center, spacing: 22) {
                        
                        Spacer()
                        
                        ForEach(eventsViewModel.eventViewModels) { eventViewModel in
                            
                            EventCell()
                                .environmentObject(eventViewModel)
                            
                        }
                    }
                    
                }
                .navigationBarTitle("MOTV", displayMode: .inline)
                .background(Color.backGroundColor)
                .zIndex(0)
                
                CreateEventButton(presentEventCreationForm: $presentEventCreationForm) // + Button to create new event
                    .zIndex(2)
                
                BottomFadeIn() // Bottom Gradient
                    .ignoresSafeArea()
                    .zIndex(1)
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {

                    NavigationLink {
                        PersonalProfileView()
                            .environmentObject(PersonalProfileViewModel(usersRepository: UsersRepository()))
                    } label: {
                        Image(systemName: "person.fill")
                    }
                    .contextMenu { TestUserSwitcher(authServices: self.testAuth, repo: UsersRepository()) }

                }
            }
            
        }
        .sheet(isPresented: $presentEventCreationForm, content: {
            EventCreationPrimaryDetailsFormView(presentEventCreationForm: $presentEventCreationForm)
                .environmentObject(EventCreationPrimaryDetailsFormViewModel(eventCreationForm: EventCreationFormViewModel(eventRepository: EventRepository(), usersRepository: UsersRepository())))
                
        })


    }
}

struct BottomFadeIn: View {
    
    private let gradient = Gradient(stops : [Gradient.Stop(color: .backGroundColor, location: 0), Gradient.Stop(color: .backGroundColor, location: 0.5), Gradient.Stop(color: .backGroundColor.opacity(0), location: 1)])
    
    var body: some View {
        VStack {
            Spacer()
            LinearGradient(gradient: gradient, startPoint: .bottom, endPoint: .top)
                .frame(width: nil, height: 90, alignment: .bottom)
        }
    }
}

struct CreateEventButton: View {
    
    @Binding var presentEventCreationForm: Bool
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Button(action: {
                presentEventCreationForm.toggle()
            }) {
                
                ZStack(alignment: .center) {
                    Text("+")
                        .offset(y: -5)
                        .font(.system(size: 70, weight: .light, design: .rounded))
                        .foregroundColor(.white)
                        .zIndex(1)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(Color.white, lineWidth: 2.5)
                        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(Color.black))
                        .frame(width: 60, height: 55, alignment: .center)
                        .zIndex(0)
                }
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventsView(eventsViewModel: EventsViewModel())
//            .preferredColorScheme(.dark)
//            .previewDevice("iPhone 11")
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
