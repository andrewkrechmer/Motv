//
//  EventCell.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-08-18.
//

import SwiftUI

import FirebaseFirestore
import FirebaseStorage

// MARK: - Parent View

struct EventCell: View {
    
    @EnvironmentObject var eventViewModel: EventViewModel
    
    var id = UUID.init()
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            VStack(alignment: .leading, spacing: 30.0) {
                EventPrimaryInfoView() // Host image, event title and time
                    .padding(.top, 20.0)
                    .layoutPriority(1)
                EventAttendeesView() // 3 images and 49 letter text displaying the most relevant attendees
                    .layoutPriority(2)
                EventSecondaryInfoView() // Secondary info (Location, activities, special policies, etc)
                    .padding(.bottom, 20.0)
                    .layoutPriority(0)
                    
            }
            .padding(.horizontal, 35.0)
            .background( // Background cell (Grey rounded rectangle)
                RoundedRectangle(cornerRadius: 15.0)
                    .scale(x: 0.95, y: 1.0, anchor: .center)
                    .foregroundColor(Color.foreGroundColor)
                    .shadow(color: .shadowColor, radius: 4.0, x: 0.0, y: 5.0)
            )

        }
    }
}


// MARK: - Secondary Child Views

// --- Primary Info View

struct EventPrimaryInfoView: View {
    
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
                    .font(.system(size: 27, weight: .bold, design: .default))
                    .multilineTextAlignment(.leading)
                    
                Text(eventViewModel.timeText) // Event Time
                    .font(.system(size: 22, weight: .medium, design: .default))
                    .multilineTextAlignment(.leading)
            }
        
        }

    }
    
}


// --- Attendees View

struct EventAttendeesView: View {
    
    @EnvironmentObject var eventViewModel: EventViewModel
    
    var body: some View {
        HStack {
            ZStack { // Event Attendees/Invitees Image
                
                if eventViewModel.attendeesImages.count >= 1 {
                    Image(uiImage: self.eventViewModel.attendeesImages[0])
                        .attendeeImage()
                        .zIndex(3.0)
                        .offset(x: 0, y: -15)
                }
                
                if eventViewModel.attendeesImages.count >= 2 {
                    Image(uiImage: eventViewModel.attendeesImages[1])
                        .attendeeImage()
                        .zIndex(2.0)
                        .offset(x: 24)
                }
                
                if eventViewModel.attendeesImages.count >= 3 {
                    Image(uiImage: eventViewModel.attendeesImages[2])
                        .attendeeImage()
                        .zIndex(1.0)
                        .offset(x: 0, y: 15)
                }
   
            }
            .padding(.trailing, 43.0)
            
            
            Text(eventViewModel.attendeesText) // Event Attendees/Invitees
                .font(.system(size: 18, weight: .medium, design: .default))
                .multilineTextAlignment(.leading)
                .allowsTightening(true)
                .lineLimit(2)
                .lineSpacing(5.0)
        }
    }
}


// --- Secondary Info View

struct EventSecondaryInfoView: View {
    
    //    var eventViewModel: EventViewModel
    
    @State var topSecondaryInfo: [SecondaryInfo] = [SecondaryInfo(text: "📍 Joana's House | 22 mins away", type: .location), SecondaryInfo(text: "25 Peopl Max ", type: .attendeeLimit), SecondaryInfo(text: "🌊  Outdoor Pool!", type: .activity)]
    @State var bottomSecondaryInfo: [SecondaryInfo] = [SecondaryInfo(text: "💉 Proof of Covid Vaccination Required", type: .activity), SecondaryInfo(text: "🎵 Music", type: .activity), SecondaryInfo(text: "🍾 BYOB", type: .activity)]
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            VStack(alignment: .leading, spacing: nil)
            {
                HStack(alignment: .center, spacing: nil)
                {
                    ForEach(topSecondaryInfo) { info in
                        SecondaryInfoCell(info: info)
                    }
                }
                HStack(alignment: .center, spacing: nil) {
                    ForEach(bottomSecondaryInfo) { info in
                        SecondaryInfoCell(info: info)
                    }
                }
            }
        }
    }
}


// MARK: - Primary Child Views

struct SecondaryInfoCell: View {
    var info: SecondaryInfo
    var body: some View {
        
        Text(info.text)
            .font(.system(size: 17, weight: .regular, design: .default))
            .padding(.all, 5.0)
            .background(ColoredRoundedRectanlge(color: info.type == .location ? /*MOTV_UI_BuildingApp.themeColor*/ Color.yellow : Color.primary))
        
    }
}

struct ColoredRoundedRectanlge: View {
    @State var color: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(color).opacity(0.1)
            .background(RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 1).foregroundColor(color).opacity(0.5))
    }
}


// MARK: - View Modifiers and Extensions

extension Image {
    
    func attendeeImage() -> some View {
        self
            .resizable()
            .contentShape(Circle())
            .aspectRatio(contentMode: .fill)
            .frame(width: 34, height: 34, alignment: .center)
            .clipped()
    }
}


// MARK: - Preview

struct EventCell_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Text("Event Cell Preview")
        
    }
    
}
