//
//  SignInViewModel.swift
//  Eventorias2
//
//  Created by Alassane Der on 15/07/2025.
//
import Foundation

@MainActor
class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isSecured: Bool = true
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let sessionManager: SessionManager
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    var isFormValid: Bool {
        !email.isEmpty && email.isEmail && !password.isEmpty && password.count >= 6
    }
    
    func signIn() async {
        isLoading = true
        defer { isLoading = false }
        
        guard isFormValid else {
            errorMessage = NSLocalizedString("auth_error_invalid_form", comment: "Invalid form input")
            return
        }
        
        do {
            let _ = try await sessionManager.authService.signIn(email: email, password: password)
            // Navigation vers eventList gérée par la vue
        } catch let error as AuthErrors {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = NSLocalizedString("auth_error_unexpected", comment: "An unexpected error occurred: \(error.localizedDescription)")
        }
    }
}
