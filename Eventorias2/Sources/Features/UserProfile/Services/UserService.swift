//
//  UserService.swift
//  Eventorias2
//
//  Created by Alassane Der on 26/07/2025.
//

import Foundation
import FirebaseFirestore

class UserService: UserServiceProtocol {
    private let db = Firestore.firestore()
    
    func fetchUsers(forIds userIds: [String]) async throws -> [String: AuthUser] {
        var users: [String: AuthUser] = [:]
        for userId in userIds {
            do {
                let document = try await db.collection("users").document(userId).getDocument()
                if let user = try? document.data(as: AuthUser.self) {
                    users[userId] = user
                    print("Fetched user: \(userId), profile picture URL: \(user.profilePictureUrl)")
                } else {
                    print("No user data found for ID: \(userId)")
                }
            } catch {
                print("Error fetching user \(userId): \(error.localizedDescription)")
                throw UserErrors.fetchFailed(error)
            }
        }
        return users
    }
}

enum UserErrors: Error, LocalizedError {
    case fetchFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .fetchFailed(let error):
            return NSLocalizedString("user_error_fetch_failed", comment: "Failed to fetch users: \(error.localizedDescription)")
        }
    }
}
