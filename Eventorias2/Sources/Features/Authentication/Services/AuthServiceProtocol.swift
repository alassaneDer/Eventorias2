//
//  AuthServiceProtocol.swift
//  Eventorias2
//
//  Created by Alassane Der on 12/07/2025.
//

import Foundation

@MainActor
protocol AuthServiceProtocol {
    var currentUser: AuthUser? { get }
    func signIn(email: String, password: String) async throws -> AuthUser
    func signUp(email: String, password: String, username: String?) async throws -> AuthUser
    func signOut() throws
}
