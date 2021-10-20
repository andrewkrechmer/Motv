//
//  MOTVApp.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-08-18.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct MOTVApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var authenticationServices = AuthenticationServices()
    
    @StateObject var eventsViewModel = EventsViewModel(eventRepository: EventRepository())
        
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            
            if authenticationServices.signedIn {

                EventsView(eventsViewModel: eventsViewModel)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(authenticationServices)

            }
            else {
                
                SignUpView(viewModel: SignUpViewModel(authenticationServices: authenticationServices))
                
            }
            
        }
        
    }
        
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    
  var window: UIWindow?
    
  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure() // Initialize Firebase Project
        Auth.auth().signInAnonymously()
        
        return true
  }
    
}
