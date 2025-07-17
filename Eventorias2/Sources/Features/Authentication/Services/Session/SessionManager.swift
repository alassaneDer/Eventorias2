//
//  SessionManager.swift
//  Eventorias2
//
//  Created by Alassane Der on 15/07/2025.
//
import FirebaseAuth
import Foundation

@MainActor
class SessionManager: ObservableObject {
    @Published var currentUser: AuthUser?
    let authService: AuthServiceProtocol
    let userProfileService: UserProfileServiceProtocol
    var authStateHandle: AuthStateDidChangeListenerHandle?
    
    init(authService: AuthServiceProtocol = AuthService(), userProfileService: UserProfileServiceProtocol = UserProfileService()) {
        self.authService = authService
        self.userProfileService = userProfileService
        self.currentUser = authService.currentUser
        setupAuthStateListener()
    }
    
    private func setupAuthStateListener() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            Task { @MainActor in
                guard let self else { return }
                if let firebaseUser {
                    do {
                        let user = try await self.userProfileService.fetchUser(id: firebaseUser.uid)
                        self.currentUser = user
                    } catch {
                        self.currentUser = AuthUser(user: firebaseUser)
                    }
                } else {
                    self.currentUser = nil
                }
            }
        }
    }
    
    var isAuthenticated: Bool {
        currentUser != nil
    }
    
    func signOut() async throws {
        try authService.signOut()
        currentUser = nil
    }
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
