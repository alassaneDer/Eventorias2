//
//  DependencyContainer.swift
//  Eventorias2
//
//  Created by Alassane Der on 16/07/2025.
//

import Foundation

@MainActor
class DependencyContainer: ObservableObject {
    let sessionManager: SessionManager
    let authService: AuthServiceProtocol
    let userProfileService: UserProfileServiceProtocol
    let eventService: EventServiceProtocol
    let userService: UserServiceProtocol
    let geocodingService: GeocodingServiceProtocol
    
    init() {
        self.authService = AuthService()
        self.userProfileService = UserProfileService()
        self.eventService = EventService()
        self.userService = UserService()
        self.geocodingService = GeocodingService()
        self.sessionManager = SessionManager(authService: authService, userProfileService: userProfileService)
    }
    
    func makeNavigationCoordinator() -> NavigationCoordinator {
        return NavigationCoordinator(sessionManager: sessionManager)
    }
    
    func makeSignUpViewModel() -> SignUpViewModel {
        return SignUpViewModel(sessionManager: sessionManager)
    }
    
    func makeSignInViewModel() -> SignInViewModel {
        return SignInViewModel(sessionManager: sessionManager)
    }
    
    func makeEventListViewModel() -> EventListViewModel {
        return EventListViewModel(eventService: eventService, userService: userService)
    }
    
    func makeEventCreateViewModel() -> EventCreateViewModel {
        return EventCreateViewModel(eventService: eventService, geocodingService: geocodingService)
    }
    
    func makeEventDetailViewModel(eventId: String) -> EventDetailViewModel {
        return EventDetailViewModel(eventId: eventId, eventService: eventService, geocodingService: geocodingService)
    }
}
