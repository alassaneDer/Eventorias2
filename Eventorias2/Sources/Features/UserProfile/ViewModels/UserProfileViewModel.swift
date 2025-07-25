//
//  UserProfileViewModel.swift
//  Eventorias2
//
//  Created by Alassane Der on 24/07/2025.
//

import Foundation

@MainActor
class UserProfileViewModel: ObservableObject {
    @Published var user: AuthUser?
    @Published var errorMessage: IdentifiableError?
    
    private let userProfileService: UserProfileServiceProtocol
    
    init(userProfileService: UserProfileServiceProtocol = UserProfileService()) {
        self.userProfileService = userProfileService
    }
    
    func fetchUser(userId: String) async {
        do {
            user = try await userProfileService.fetchUser(id: userId)
        } catch {
            errorMessage = IdentifiableError(message: error.localizedDescription)
        }
    }
    
    func uploadProfilePicture(data: Data, forUserId: String) async {
        do {
            let url = try await userProfileService.uploadProfilePicture(data, forUserId: forUserId)
            if var currentUser = user {
                currentUser.profilePictureUrl = url
                user = currentUser
                try await userProfileService.createUser(currentUser)
            }
        } catch {
            errorMessage = IdentifiableError(message: error.localizedDescription)
        }
    }
    
    func updateNotificationsEnabled(_ enabled: Bool, forUserId: String) async {
        do {
            if var currentUser = user {
                currentUser.notificationsEnabled = enabled
                user = currentUser
                try await userProfileService.createUser(currentUser)
            }
        } catch {
            errorMessage = IdentifiableError(message: error.localizedDescription)
        }
    }
}
