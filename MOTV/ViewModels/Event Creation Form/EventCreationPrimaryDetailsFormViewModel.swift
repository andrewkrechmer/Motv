//
//  EventCreationPrimaryDetailsFormViewModel.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-09-26.
//

import Foundation

import SwiftUI
import Combine

class EventCreationPrimaryDetailsFormViewModel: ObservableObject {
    
    @Published var eventCreationFormViewModel: EventCreationFormViewModel
    
    @Published var formIsValid: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(eventCreationForm: EventCreationFormViewModel) {
        
        self.eventCreationFormViewModel = eventCreationForm
        
        eventDetailsAreValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.formIsValid, on: self)
            .store(in: &cancellables)
    }
    
    private var eventNameIsValid: AnyPublisher<Bool, Never> {
        eventCreationFormViewModel.$eventName
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0.count > 1 }
            .eraseToAnyPublisher()
    }
    
    private var startDateIsValid: AnyPublisher<Bool, Never> {
        eventCreationFormViewModel.$startDate
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0 >= Date() - 1 }
            .eraseToAnyPublisher()
    }
    
    private var endDateIsValid: AnyPublisher<Bool, Never> {
        eventCreationFormViewModel.$endDate
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0 > self.eventCreationFormViewModel.startDate + 1}
            .eraseToAnyPublisher()
    }
    
    private var locationIsValid: AnyPublisher<Bool, Never> {
        eventCreationFormViewModel.$location
            .removeDuplicates()
            .map { $0 != SavedLocation(commonName: "", addressString: "", latitude: 0, longitude: 0) }
            .eraseToAnyPublisher()
    }
    
    private var eventDetailsAreValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(eventNameIsValid, startDateIsValid, endDateIsValid, locationIsValid)
            .map { $0 && $1 && $2 && $3 }
            .eraseToAnyPublisher()
    }
    
}
