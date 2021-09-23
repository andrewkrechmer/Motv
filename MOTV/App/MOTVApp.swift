//
//  MOTVApp.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-08-18.
//

import SwiftUI
import Firebase

@main
struct MOTVApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var eventsViewModel = EventsViewModel()
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            EventsView(eventsViewModel: eventsViewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Auth.auth().signInAnonymously()
        
        return true
  }
}
