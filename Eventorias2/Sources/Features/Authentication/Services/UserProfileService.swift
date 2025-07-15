//
//  UserProfileService.swift
//  Eventorias2
//
//  Created by Alassane Der on 12/07/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

@MainActor
class UserProfileService: UserProfileServiceProtocol {
    
    private let firestore: Firestore
    private let storage: Storage
    private let usersDocumentName: String = "users"
    
    init(firestore: Firestore = .firestore(), storage: Storage = .storage()) {
        self.firestore = firestore
        self.storage = storage
    }
    
    func createUser(_ user: AuthUser) async throws {
        guard let userId = user.id, !userId.isEmpty else {
            throw AuthErrors.userProfile(.invalidUserId)
        }
        do {
            try firestore.collection(usersDocumentName).document(userId).setData(from: user)
        } catch {
            throw AuthErrors.userProfile(.firestoreWriteFailed)
        }
    }
    
    func fetchUser(id: String) async throws -> AuthUser {
        guard !id.isEmpty else {
            throw AuthErrors.userProfile(.invalidUserId)
        }
        do {
            let document = try await firestore.collection(usersDocumentName).document(id).getDocument()
            
            if !document.exists {
                throw AuthErrors.userProfile(.userNotFound)
            }
            
            let user = try document.data(as: AuthUser.self)
            return user
        } catch {
            // Si l'erreur est déjà un AuthErrors, on la relance
            if let authError = error as? AuthErrors {
                throw authError
            }
            // Sinon, on encapsule l'erreur dans Common.unexpected
            throw AuthErrors.common(.unexpected(error))
        }
    }
    
    
    
    func uploadProfilePicture(_ image: UIImage, forUserId: String) async throws -> String {
        guard !forUserId.isEmpty else {
            throw AuthErrors.userProfile(.invalidUserId)
        }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw AuthErrors.userProfile(.invalidImageData)
        }
        
        do {
            let storageRef = storage.reference().child("profile_pictures/\(forUserId).jpg")
            let _ = try await storageRef.putDataAsync(imageData)
            let downloadURL = try await storageRef.downloadURL()
            return downloadURL.absoluteString
        } catch let error as NSError {
            switch error.code {
            case StorageErrorCode.unauthorized.rawValue:
                throw AuthErrors.userProfile(.firestoreWriteFailed)
            default:
                throw AuthErrors.common(.unexpected(error))
            }
        }
    }
    
    
}
