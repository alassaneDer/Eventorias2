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
    
    lazy var manager: SessionManager = {
        SessionManager()
    }() /// pas charger si pas utiliser tout de suite, qu'en cas d'utilisation
    ///si pas besoin au demarrage
    
    init() {
        self.authService = AuthService()
        self.userProfileService = UserProfileService()
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
        return EventListViewModel()
    }
}
/// attention:  initialiser que ce dont j'ai besoin au demarrage
/// LazyVar
