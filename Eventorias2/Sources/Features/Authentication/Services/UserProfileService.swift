//
//  UserProfileService.swift
//  Eventorias2
//
//  Created by Alassane Der on 12/07/2025.
//

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
