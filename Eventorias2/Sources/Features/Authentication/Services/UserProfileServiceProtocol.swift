//
//  UserProfileServiceProtocol.swift
//  Eventorias2
//
//  Created by Alassane Der on 12/07/2025.
//

import Foundation

protocol UserProfileServiceProtocol {
    func fetchUser(id: String) async throws -> AuthUser
    func createUser(_ user: AuthUser) async throws
    func uploadProfilePicture(_ data: Data, forUserId: String) async throws -> String
}
