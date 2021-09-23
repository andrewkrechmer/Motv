//
//  ContentView.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-08-18.
//

import SwiftUI
import CoreData

struct EventsView: View {
    
    @ObservedObject var eventsViewModel: EventsViewModel
    
    var body: some View {
        
        NavigationView {
            
            List {
                
                ForEach(eventsViewModel.eventViewModels) { eventViewModel in
                    EventCell()
                        .environmentObject(eventViewModel)
                }
                
            }
        }
        
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView(eventsViewModel: EventsViewModel())
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 11")
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
