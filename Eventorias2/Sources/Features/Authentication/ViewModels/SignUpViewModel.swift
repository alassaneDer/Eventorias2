//
//  SignUpViewModel.swift
//  Eventorias2
//
//  Created by Alassane Der on 15/07/2025.
//

import Foundation

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var profilePictureData: Data?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let sessionManager: SessionManager
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    var isFormValid: Bool {
        !email.isEmpty && email.isEmail && !password.isEmpty && password.count >= 6 && password == confirmPassword
    }
    
    func signUp() async {
        isLoading = true
        defer { isLoading = false }
        
        guard isFormValid else {
            errorMessage = NSLocalizedString("auth_error_invalid_form", comment: "Invalid form input")
            return
        }
        
        do {
            let user = try await sessionManager.authService.signUp(email: email, password: password, username: username.isEmpty ? nil : username)
            if let profilePictureData = profilePictureData {
                let profilePictureUrl = try await sessionManager.userProfileService.uploadProfilePicture(profilePictureData, forUserId: user.id!)
                var updatedUser = user
                updatedUser.profilePictureUrl = profilePictureUrl
                try await sessionManager.userProfileService.createUser(updatedUser)
            }
            // Navigation vers eventList gérée par la vue
        } catch let error as AuthErrors {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = NSLocalizedString("auth_error_unexpected", comment: "An unexpected error occurred: \(error.localizedDescription)")
        }
    }
}
