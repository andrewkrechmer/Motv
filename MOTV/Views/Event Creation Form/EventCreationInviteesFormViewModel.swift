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

class EventCreationInviteesFormViewModel: EventCreationFormViewModel {
    
    @Published var formIsValid: Bool = false
    
    @Published var friends: [UserViewModel] =  TestAssistant.directFriends
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        
        super.init()
        
        eventInviteesFormIsValid
            .receive(on: RunLoop.main)
            .assign(to: \.formIsValid, on: self)
            .store(in: &cancellables)
    }
    
    private var inviteesAreValid: AnyPublisher<Bool, Never> {
        $invitees
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0.count >= 1 }
            .eraseToAnyPublisher()
    }
    
    private var minimumAttendeesIsValid: AnyPublisher<Bool, Never> {
        $minimumAttendees
            //.debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0 > 0 }
            .eraseToAnyPublisher()
    }
    
    private var maximumAttendeesIsValid: AnyPublisher<Bool, Never> {
        $maximumAttendees
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
    var id: DocumentReference
    var firstName: String
    var lastName: String
    var profileImage: UIImage
    @Published var highlight: Bool
    
    init(firstName: String, lastName: String, profileImage: UIImage, highlight: Bool) {
        self.firstName = firstName
        self.lastName = lastName
        self.profileImage = profileImage
        self.highlight = highlight
        
        let eventRepository = EventRepository()
        self.id = eventRepository.db.collection("users").document(firstName)
    }
    
}



// MARK: - Test Data

struct TestAssistant {
    
    static let directFriends: [UserViewModel] = [
        UserViewModel(firstName: "Greg", lastName: "Sway", profileImage: UIImage(imageLiteralResourceName: "Man Profile #1"), highlight: false),
        UserViewModel(firstName: "Dufas", lastName: "Dakota", profileImage: UIImage(imageLiteralResourceName: "Woman Profile #1"), highlight: false),
        UserViewModel(firstName: "Bob", lastName: "Dwindle", profileImage: UIImage(imageLiteralResourceName: "Man Profile #2"), highlight: false),
        UserViewModel(firstName: "Lorax", lastName: "Orlanda", profileImage: UIImage(imageLiteralResourceName: "Woman Profile #2"), highlight: false),
        UserViewModel(firstName: "Holister", lastName: "Tamn", profileImage: UIImage(imageLiteralResourceName: "Man Profile #3"), highlight: false),
        UserViewModel(firstName: "Alpham", lastName: "Popari", profileImage: UIImage(imageLiteralResourceName: "Woman Profile #3"), highlight: false),
        UserViewModel(firstName: "Taki", lastName: "Atalono", profileImage: UIImage(imageLiteralResourceName: "Man Profile #4"), highlight: false),
        UserViewModel(firstName: "Yuf", lastName: "Bruf", profileImage: UIImage(imageLiteralResourceName: "Woman Profile #4"), highlight: false),
        UserViewModel(firstName: "Rori", lastName: "Bambardo", profileImage: UIImage(imageLiteralResourceName: "Man Profile #5"), highlight: false),
        UserViewModel(firstName: "Gambles", lastName: "Quon", profileImage: UIImage(imageLiteralResourceName: "Woman Profile #5"), highlight: false),
    ]
    
}
