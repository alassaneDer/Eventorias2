//
//  AuthErrors.swift
//  Eventorias2
//
//  Created by Alassane Der on 14/07/2025.
//

import Foundation

enum AuthErrors: Error {
    
    enum Common: LocalizedError {
        case networkError
        case unexpected(Error)
        
        var errorDescription: String? {
            switch self {
            case .networkError:
                return NSLocalizedString("auth_error_network", comment: "Network error, please try againt.")
            case .unexpected(let error):
                return NSLocalizedString("auth_error_unspected", comment: "An unexpected error occured : \(error.localizedDescription)")
            }
        }
    }
    
    enum SignIn: LocalizedError {
        case invalidCredentials
        case userNotFound
        
        var errorDescription: String? {
            switch self {
            case .invalidCredentials: return NSLocalizedString("auth_error_invalid_credentials", comment: "Invalid email or password")
            case .userNotFound: return NSLocalizedString("auth_error_user_not_found", comment: "User not found")
            }
        }
    }
    
    enum SignUp: LocalizedError {
        case emailInUse
        case weakPassword
        case invalidEmail
        
        var errorDescription: String? {
            switch self {
            case .emailInUse: return NSLocalizedString("auth_error_email_in_use", comment: "Email already in use")
            case .weakPassword: return NSLocalizedString("auth_error_weak_password", comment: "The password is too weak")
            case .invalidEmail: return NSLocalizedString("auth_error_invalid_email", comment: "The email adress is invalid")
            }
        }
    }
    
    enum UserProfile: LocalizedError {
        case userNotFound
        case invalidImageData
        case invalidUserId
        case firestoreWriteFailed
        
        var errorDescription: String? {
            switch self {
            case .userNotFound: return NSLocalizedString("auth_error_user_not_found", comment: "User profile not found")
            case .invalidImageData: return NSLocalizedString("auth_error_invalid_image_data", comment: "Invalid image data")
            case .invalidUserId: return NSLocalizedString("auth_error_invalid_userId", comment: "Invalid user ID")
            case .firestoreWriteFailed: return NSLocalizedString("auth_error_firestore_write_failed", comment: "Failed to write to data base")
            }
        }
    }
    
    case common(Common)
    case signIn(SignIn)
    case signUp(SignUp)
    case userProfile(UserProfile)
    case signOut(Error)
    
    var errorDescription: String? {
            switch self {
            case .common(let error):
                return error.errorDescription
            case .signIn(let error):
                return error.errorDescription
            case .signUp(let error):
                return error.errorDescription
            case .userProfile(let error):
                return error.errorDescription
            case .signOut(let error):
                return NSLocalizedString("auth_error_sign_out", comment: "Log out error : \(error.localizedDescription)")
            }
        }
}
