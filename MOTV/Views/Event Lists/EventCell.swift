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
                EventPrimaryInfoView()
                    .padding(.top, 20.0)
                    .layoutPriority(1)
                Divider()
                
                EventAttendeesView()
                    .layoutPriority(2)
                EventActionButtonsView()
                    .padding(.bottom, 20.0)
                    .layoutPriority(0)
                    
            }
            .padding(.horizontal, 35.0)
            .background( // Background cell (Grey rounded rectangle)
                RoundedRectangle(cornerRadius: 15.0)
                    .scale(x: 0.95, y: 1.0, anchor: .center)
                    .foregroundColor(Color.foreGroundColor)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .scale(x: 0.95, y: 1.0, anchor: .center)
                            .stroke(ThemeColors.gradient, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    )
                
                    
                    
                    //.shadow(color: .shadowColor, radius: 4.0, x: 0.0, y: 5.0)
            )

        }
    }
}


// MARK: - Secondary Child Views

// --- Primary Info View

struct EventPrimaryInfoView: View {
    
    @EnvironmentObject var eventViewModel: EventViewModel
    
    var body: some View {
        
        HStack(alignment: .top) {
            Image(uiImage: eventViewModel.hostImage) // Event Host Image
                .resizable()
                .contentShape(Circle())
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100, alignment: .center)
                .clipped()
                .padding(.trailing, 28.0)

            VStack(alignment: .leading, spacing: 7) {
                Text(self.eventViewModel.nameText) // Event Title
                    .font(.system(size: 27, weight: .bold, design: .default))
                    .multilineTextAlignment(.leading)
                    
                Text(eventViewModel.timeText) // Event Time
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .multilineTextAlignment(.leading)
                
                Text(eventViewModel.locationText)
                    .font(.system(size: 18, weight: .regular, design: .default)).foregroundColor(.gray)
            }
        
        }

    }
    
}


// -- Attendees View

struct EventAttendeesView: View {
    
    @EnvironmentObject var eventViewModel: EventViewModel
    
    var body: some View {
        
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem()], spacing: 20) {
            ForEach(eventViewModel.attendeesInfo) { user in
                VStack {
                    Image(uiImage: user.profileImage)
                        .attendeeImage()
                    Text(user.name)
                        .font(.system(size: 14, weight: .regular, design: .default))
                }
            }
        }
        
    }

    
}


// -- Button View

struct EventActionButtonsView: View {
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 20) {
            EventActionButtonView(buttonType: .moreInfo)
            EventActionButtonView(buttonType: .moreInfo)
            EventActionButtonView(buttonType: .moreInfo)
            EventActionButtonView(buttonType: .moreInfo)
        }
        
    }
    
}

struct EventActionButtonView: View {
    
    enum ButtonType {
        case moreInfo
        case accept
        case unsure
        case decline
        case groupChat
        case invitePlusOne
    }
    
    var buttonType: ButtonType
    
    var body: some View {
        ZStack {
            
            switch buttonType {
                case .moreInfo:
                    Text("+")
                    
                default:
                    Text("")
            }
            
            Circle()
                .foregroundColor(.clear)
                .background(ThemeColors.gradient).opacity(0.3)
                .background(Circle().stroke(ThemeColors.gradient, style: StrokeStyle(lineWidth: 2, lineCap: .round)))
                .clipShape(Circle())
            .frame(width: 55, height: 55, alignment: .center)
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
            .frame(width: 70, height: 70, alignment: .center)
            .clipped()
    }
}


// MARK: - Preview

struct EventCell_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Text("Event Cell Preview")
        
    }
    
}
