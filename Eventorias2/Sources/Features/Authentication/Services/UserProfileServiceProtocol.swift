//
//  UserProfileServiceProtocol.swift
//  Eventorias2
//
//  Created by Alassane Der on 12/07/2025.
//

import Foundation
import UIKit

protocol UserProfileServiceProtocol {
    func createUser(_ user: AuthUser) async throws
    func fetchUser(id: String) async throws -> AuthUser
    func uploadProfilePicture(_ image: UIImage, forUserId: String) async throws -> String
}
