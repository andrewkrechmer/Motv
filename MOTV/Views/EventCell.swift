//
//  EventCell.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-08-18.
//

import SwiftUI

import FirebaseFirestore
import FirebaseStorage

// MARK: - Main View

struct EventCell: View {
    
    @EnvironmentObject var eventViewModel: EventViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 25.0) {
            EventMainInfoView()
            EventAttendeesView()
        }
    }
}


// MARK: - Supporting Views

struct EventMainInfoView: View {
    
    @EnvironmentObject var eventViewModel: EventViewModel
    
    var body: some View {
        
        HStack {
            Image(uiImage: eventViewModel.hostImage) // Event Host Image
                .resizable()
                .contentShape(Circle())
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50, alignment: .center)
                .clipped()
                .padding(.trailing, 28.0)

            VStack() {
                Text(self.eventViewModel.nameText) // Event Title
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 0.0)
                    // TODO: Take care of titles that are too long
                Text(eventViewModel.timeText) // Event Time
                    .font(.headline)
                    .multilineTextAlignment(.leading)
            }
        
        }

    }
    
}

struct EventAttendeesView: View {
    
    @EnvironmentObject var eventViewModel: EventViewModel
    
    var body: some View {
        HStack {
            ZStack { // Event Attendees/Invitees Image
                Image(uiImage: self.eventViewModel.attendeesImages[0])
                    .resizable()
                    .contentShape(Circle())
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 34, height: 34, alignment: .center)
                    .clipped()
                    .zIndex(3.0)
                    .offset(x: 0, y: -15)
                Image(uiImage: eventViewModel.attendeesImages[1])
                    .resizable()
                    .contentShape(Circle())
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 34, height: 34, alignment: .center)
                    .clipped()
                    .zIndex(2.0)
                    .offset(x: 24)
                Image(uiImage: eventViewModel.attendeesImages[2])
                    .resizable()
                    .contentShape(Circle())
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 34, height: 34, alignment: .center)
                    .clipped()
                    .zIndex(1.0)
                    .offset(x: 0, y: 15)
            }
            .padding(.trailing, 43.0)
            
            
            Text(eventViewModel.attendeesText) // Event Attendees/Invitees
                .multilineTextAlignment(.leading)
                .allowsTightening(true)
                .lineLimit(2)
                .minimumScaleFactor(0.2)
                .alignmentGuide(.top) { _ in 0 }
                // TODO: Take care of strings that are too long
        }
        
    }
    
}


// MARK: - Preview

struct EventCell_Previews: PreviewProvider {
    
    static var previews: some View {
        
        NavigationView {
        
            List {
                
                ForEach(testEventViewModels) { eventViewModel in
                    EventCell()
                        .environmentObject(eventViewModel)
                }
                
            }
            
        }
        .preferredColorScheme(.dark)
        .previewDevice("iPhone 11")
        
    }
    
    // -- Test Data
    
    static let db = Firestore.firestore()
    
    static let testEventViewModels = [EventViewModel(event: Event(draft: false, host: db.document("users/Rewey4UtqjURfMguLyJT"), name: "Andrew's Party", start: 1630108800, end: 1630121400, location: Location(commonName: "Andrew's House", shortAddress: "58 Stonebriar Dr.", type: "House", latitude: 45.340197, longitude: -75.769407), activities: ["Hockey", "Football", "Basketball"], invitees: [db.document("users/6RIkpp52OPTsefjClJz8"), db.document("users/RrIBj00u0sFpDPbzT8Hm"), db.document("users/cO3QaVSRAgiv2omEBJ4i"), db.document("users/wVQkfuebrDeEchwpQLro")], confirmedAttendees: [db.document("users/6RIkpp52OPTsefjClJz8"), db.document("users/cO3QaVSRAgiv2omEBJ4i")], minAttendees: 5, maxAttendees: 8, plusOnesAllowed: true))]
    
}
