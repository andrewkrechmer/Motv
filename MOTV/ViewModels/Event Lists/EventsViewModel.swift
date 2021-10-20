//
//  EventsViewModel.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-08-18.
//

import SwiftUI
import Combine

class EventsViewModel: ObservableObject {
    
    @Published var eventRepository: EventRepository
    
    @Published var eventViewModels = [EventViewModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(eventRepository: EventRepository) {
        
        self.eventRepository = eventRepository
        
        eventRepository.$events.map { events in
            events.map { event in
                EventViewModel(usersRepository: UsersRepository(), event: event)
            }
        }
        .assign(to: \.eventViewModels, on: self)
        .store(in: &cancellables)
    }
    
}
