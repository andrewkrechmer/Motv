//
//  EventCreationSecondaryDetailsFormViewModel.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-09-26.
//

import Foundation

class EventCreationSecondaryDetailsFormViewModel: ObservableObject {
    
    @Published var eventCreationFormViewModel: EventCreationFormViewModel
    
    @Published var formIsValid: Bool = false
    
    init(eventCreationForm: EventCreationFormViewModel) {
        self.eventCreationFormViewModel = eventCreationForm
    }
    
}
