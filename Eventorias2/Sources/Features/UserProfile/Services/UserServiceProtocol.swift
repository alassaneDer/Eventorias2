//
//  UserServiceProtocol.swift
//  Eventorias2
//
//  Created by Alassane Der on 26/07/2025.
//

import Foundation

protocol UserServiceProtocol {
    func fetchUsers(forIds userIds: [String]) async throws -> [String: AuthUser]
}
