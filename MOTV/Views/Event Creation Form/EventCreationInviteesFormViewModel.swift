//
//  EventCreationInviteesFormViewModel.swift
//  MOTV
//
//  Created by Andrew Krechmer on 2021-09-26.
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class EventCreationInviteesFormViewModel: ObservableObject {
    
    @Published var eventCreationFormViewModel: EventCreationFormViewModel
    
    @Published var usersRepository: UsersRepository
    
    @Published var formIsValid: Bool = false
    
    @Published var friendViewModels = [UserViewModel]()
    
    var numFriendViewModelsDisplayed = 0 {
        didSet {
            // If less than 10 friend view models left get more from repository
            if friendViewModels.count - numFriendViewModelsDisplayed < 10 {
                retreiveFriends()
            }
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(eventCreationForm: EventCreationFormViewModel, eventRepository: EventRepository, usersRepository: UsersRepository) {
        
        self.eventCreationFormViewModel = eventCreationForm
        
        self.usersRepository = usersRepository
        
        // Subscribe to the repositories friends array
        
        usersRepository.$friends.map { friends in
            
            friends.map { friend in
                UserViewModel(id: friend.id ?? "", firstName: friend.firstName, lastName: friend.lastName, profileImage: friend.profileImage)
            }
        }
        .assign(to: \.friendViewModels, on: self)
        .store(in: &cancellables)
        
        
        // Retreive first batch of friends
        
        retreiveFriends()
        
        
        //
        
        eventInviteesFormIsValid
            .receive(on: RunLoop.main)
            .assign(to: \.formIsValid, on: self)
            .store(in: &cancellables)
    }
    
    func retreiveFriends() {
        
        usersRepository.retreiveFriends(batchSize: 20)
        
    }
    
    private var inviteesAreValid: AnyPublisher<Bool, Never> {
        eventCreationFormViewModel.$invitees
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0.count >= 1 }
            .eraseToAnyPublisher()
    }
    
    private var minimumAttendeesIsValid: AnyPublisher<Bool, Never> {
        eventCreationFormViewModel.$minimumAttendees
            //.debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0 > 0 }
            .eraseToAnyPublisher()
    }
    
    private var maximumAttendeesIsValid: AnyPublisher<Bool, Never> {
        eventCreationFormViewModel.$maximumAttendees
            //.debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0 > 0 && $0 < 599 }
            .eraseToAnyPublisher()
    }
    
    
    private var eventInviteesFormIsValid: AnyPublisher<Bool, Never> {
        
        Publishers.CombineLatest3(inviteesAreValid, minimumAttendeesIsValid, maximumAttendeesIsValid)
            .map { $0 && $1 && $2 }
            .eraseToAnyPublisher()
        
    }
    
    
}
class UserViewModel: ObservableObject, Identifiable {
    var id: String
    var firstName: String
    var lastName: String
    var profileImage: UIImage
    
    var highlight: Bool
    
    init(id: String, firstName: String, lastName: String, profileImage: Data) {
        
        self.id = id
        
        self.firstName = firstName
        self.lastName = lastName
        
        self.profileImage = UIImage(data: profileImage) ?? UIImage(systemName: "Person")!
        
        self.highlight = false
        
    }
    
}



