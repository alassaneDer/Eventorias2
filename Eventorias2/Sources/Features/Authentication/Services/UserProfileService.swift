//
//  UserProfileService.swift
//  Eventorias2
//
//  Created by Alassane Der on 12/07/2025.
//

/*
import FirebaseFirestore
import FirebaseStorage

class UserProfileService: UserProfileServiceProtocol {
    private let firestore: Firestore
    private let storage: Storage
    private let usersDocumentName = "users"
    
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
            if let authError = error as? AuthErrors {
                throw authError
            }
            throw AuthErrors.common(.unexpected(error))
        }
    }
    
    func uploadProfilePicture(_ imageData: Data, forUserId: String) async throws -> String {
        guard !forUserId.isEmpty else {
            throw AuthErrors.userProfile(.invalidUserId)
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
*/


import FirebaseFirestore
import FirebaseStorage
import Foundation

class UserProfileService: UserProfileServiceProtocol {
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    func fetchUser(id: String) async throws -> AuthUser {
        do {
            let document = try await db.collection("users").document(id).getDocument()
            if document.exists {
                return try document.data(as: AuthUser.self)
            } else {
                throw AuthErrors.SignIn.userNotFound
            }
        } catch {
            throw AuthErrors.SignIn.userNotFound
        }
    }
    
    func createUser(_ user: AuthUser) async throws {
        try db.collection("users").document(user.id ?? UUID().uuidString).setData(from: user)
    }
    
    func uploadProfilePicture(_ data: Data, forUserId: String) async throws -> String {
        let storageRef = storage.child("profilePictures/\(forUserId)/profile.jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        _ = try await storageRef.putDataAsync(data, metadata: metadata)
        let downloadURL = try await storageRef.downloadURL()
        return downloadURL.absoluteString
    }
}
