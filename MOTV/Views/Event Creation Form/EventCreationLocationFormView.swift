//
//  EventCreationLocationFormView.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-09-26.
//

import SwiftUI
import MapKit
import CoreLocation

struct EventCreationLocationFormView: View {
    
    var locationManager = CLLocationManager()
    var locationServices = LocationServices()
    
    @ObservedObject var mapModel: EventCreationLocationFormViewModel
    
    @State var savedLocations: [SavedLocation]
    
    @Binding var locationSelection: SavedLocation
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var locationSearchFieldIselected: Bool = false
    
    
    var body: some View {
        
        VStack {
            
            // -- Text Field
            
            HStack(alignment: .center) {
                
                TextField("Search Locations", text: $mapModel.searchText) { editing in
                    locationSearchFieldIselected.toggle()
                } onCommit: {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.system(size: 16, weight: .medium, design: .default))
                .padding(.leading, 12)
                .padding(.vertical, 8)
                .background(FormFieldBackground(isSelected: $locationSearchFieldIselected))
                .frame(width: nil, height: 25, alignment: .leading)
                .onChange(of: mapModel.searchText) { value in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.mapModel.searchQuery()
                    }
                }

                Button {
                    hideKeyboard()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
                
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            
            
            // -- Results List
            
            List {
                
                Section(header: Text("Search Results")) {
                    
                    ForEach(mapModel.searchResults, id: \.self.postalCode) { location in
                     
                        LocationListItem(image: Image(systemName: "mappin.and.ellipse"), locationCommonName: location.name ?? "Spot", locationAddress: location.thoroughfare ?? "")
                            .onTapGesture {
                                locationSelection = SavedLocation(commonName: location.name ?? "", addressString: location.thoroughfare ?? "", latitude: location.location?.coordinate.latitude ?? 0, longitude: location.location?.coordinate.longitude ?? 0)
                                presentationMode.wrappedValue.dismiss()
                            }
                    
                    }
                    
                }
                
                Section(header: Text("Saved Spots")) {
                    
                    ForEach(savedLocations) { location in
                     
                        LocationListItem(image: Image(systemName: "mappin.and.ellipse"), locationCommonName: location.commonName, locationAddress: location.addressString)
                            .onTapGesture {
                                locationSelection = location
                                presentationMode.wrappedValue.dismiss()
                            }
                    
                    }
                }
                
            }
            .id(UUID())
            .listStyle(InsetGroupedListStyle())
            
        }
        .onAppear() {
            locationManager.delegate = locationServices
            locationManager.requestWhenInUseAuthorization()
        }
        .onTapGesture {
            hideKeyboard()
        }
    
    }
    
}


struct LocationListItem: View {
    
    var image: Image
    var locationCommonName: String
    var locationAddress: String
    
    var body: some View {
        
        HStack(alignment: .center) {
            
            image
                .padding(7)
            
            VStack(alignment: .leading) {
                Text(locationCommonName)
                    .font(.headline)
                
                Text(locationAddress)
                    .font(.caption)
            }
            
        }
        
    }
}


// MARK: - Test Data

struct TestData {
    
    static var testSavedLocations: [SavedLocation] = [
        
        SavedLocation(commonName: "Andrew's House", addressString: "58 Stonebriar Dr", latitude: 5423, longitude: 5423),
        SavedLocation(commonName: "The Soup Coup", addressString: "21 Savage Dr", latitude: 5423, longitude: 5423),
        SavedLocation(commonName: "Burger King", addressString: "69 Sammi Av", latitude: 5423, longitude: 5423),
        SavedLocation(commonName: "Apple", addressString: "1 Infinite Loop", latitude: 5423, longitude: 5423),
        
    ]
    
}

struct EventCreationLocationFormView_Previews: PreviewProvider {
    static var previews: some View {
        
        Text("Event Creation Location Form Preview")
        
    }
}
