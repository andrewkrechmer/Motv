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
    
    var loadedModelsStore: [String] = [] {
        willSet {
            self.loadedModels = newValue.uniqued()
        }
    }
    
    var loadedModels: [String] = [] {
        didSet {
            // If less than 10 friend view models left get more from repository
            if friendViewModels.count - loadedModels.count < 5 && loadedModels.count % 5 == 0 {
                    self.retreiveFriends()
            }
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(eventCreationForm: EventCreationFormViewModel, eventRepository: EventRepository, usersRepository: UsersRepository) {
        
        self.eventCreationFormViewModel = eventCreationForm
        
        self.usersRepository = usersRepository
        
        // Retreive first batch of friends
        
        retreiveFriends()
        
        
        //
        
        eventInviteesFormIsValid
            .receive(on: RunLoop.main)
            .assign(to: \.formIsValid, on: self)
            .store(in: &cancellables)
    }
    
    func retreiveFriends() {
        
        usersRepository.retreiveFriends(batchSize: 20) { retreivedFriends in
            
            for friend in retreivedFriends {
                    self.friendViewModels.append(UserViewModel(id: friend.id ?? "", firstName: friend.firstName, lastName: friend.lastName, profileImage: friend.profileImage))
            }
            
        }
        
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
    @Published var profileImage: UIImage
    
    @Published var highlight: Bool
    
    var profileImageURL: String
    
    init(id: String, firstName: String, lastName: String, profileImage: String) {
        
        self.id = id
        
        self.firstName = firstName
        self.lastName = lastName
        
        self.profileImage = UIImage(systemName: "Person")?.withTintColor(.blue) ?? UIImage(ciImage: CIImage(color: CIColor.blue))
        
        self.highlight = false
        
        self.profileImageURL = profileImage
        
        self.fetchImage()
        
    }
    
    func fetchImage() {
        let imageFetcher = ImageFetcher()
        imageFetcher.fetchImage(with: self.profileImageURL) { image in
            self.profileImage = image
            self.objectWillChange.send()
        }
    }
    
}



extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
