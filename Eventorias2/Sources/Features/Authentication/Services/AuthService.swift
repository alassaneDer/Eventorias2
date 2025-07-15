//
//  AuthService.swift
//  Eventorias2
//
//  Created by Alassane Der on 12/07/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class AuthService: AuthServiceProtocol {
    private let auth: Auth
    private let firestore: Firestore
    private let userProfileService: UserProfileServiceProtocol
    
    init(auth: Auth = .auth(), firestore: Firestore = .firestore(), userProfileService: UserProfileServiceProtocol? = nil) {
        self.auth = auth
        self.firestore = firestore
        self.userProfileService = userProfileService ?? UserProfileService(firestore: firestore)
    }
    
    var currentUser: AuthUser? {
        guard let firebaseUser = auth.currentUser else { return nil }
        return AuthUser(user: firebaseUser)
    }
    
    func signIn(email: String, password: String) async throws -> AuthUser {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            return try await userProfileService.fetchUser(id: result.user.uid)
        } catch let error as NSError {
            switch error.code {
            case AuthErrorCode.invalidEmail.rawValue, AuthErrorCode.wrongPassword.rawValue:
                throw AuthErrors.signIn(.invalidCredentials)
            case AuthErrorCode.userNotFound.rawValue:
                throw AuthErrors.signIn(.userNotFound)
            case AuthErrorCode.networkError.rawValue:
                throw AuthErrors.common(.networkError)
            default:
                throw AuthErrors.common(.unexpected(error))
            }
        }
    }
    
    func signUp(email: String, password: String, username: String?) async throws -> AuthUser {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            let authUser = AuthUser(user: result.user, username: username)
            try await userProfileService.createUser(authUser)
            return authUser
        } catch let error as NSError {
            switch error.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                throw AuthErrors.signUp(.emailInUse)
            case AuthErrorCode.weakPassword.rawValue:
                throw AuthErrors.signUp(.weakPassword)
            case AuthErrorCode.invalidEmail.rawValue:
                throw AuthErrors.signUp(.invalidEmail)
            case AuthErrorCode.networkError.rawValue:
                throw AuthErrors.common(.networkError)
            default:
                throw AuthErrors.common(.unexpected(error))
            }
        }
    }
    
    func signOut() throws {
        do {
            try auth.signOut()
        } catch {
            throw AuthErrors.signOut(error)
        }
    }
}
