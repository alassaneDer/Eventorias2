//
//  MockAuth.swift
//  Eventorias2Tests
//
//  Created by Alassane Der on 07/08/2025.
//

import Foundation
@testable import Eventorias2

// Protocole pour simuler Auth
protocol MockAuthProtocol {
    var currentUser: MockUser? { get }
    func signIn(withEmail email: String, password: String) async throws -> MockAuthDataResult
    func createUser(withEmail email: String, password: String) async throws -> MockAuthDataResult
    func signOut() throws
    func addStateDidChangeListener(_ listener: @escaping (MockAuthProtocol, MockUser?) -> Void) -> MockAuthStateDidChangeListenerHandle
    func removeStateDidChangeListener(_ listener: MockAuthStateDidChangeListenerHandle)
}

class MockAuth: MockAuthProtocol {
    var mockCurrentUser: MockUser?
    var signInError: Error?
    var signUpError: Error?
    var signOutError: Error?
    var stateChangeHandler: ((MockAuthProtocol, MockUser?) -> Void)?
    
    var currentUser: MockUser? {
        mockCurrentUser
    }
    
    func signIn(withEmail email: String, password: String) async throws -> MockAuthDataResult {
        if let signInError {
            throw signInError
        }
        let mockUser = MockUser(uid: "mockUserId", email: email)
        mockCurrentUser = mockUser
        return MockAuthDataResult(user: mockUser)
    }
    
    func createUser(withEmail email: String, password: String) async throws -> MockAuthDataResult {
        if let signUpError {
            throw signUpError
        }
        let mockUser = MockUser(uid: "mockUserId", email: email)
        mockCurrentUser = mockUser
        return MockAuthDataResult(user: mockUser)
    }
    
    func signOut() throws {
        if let signOutError {
            throw signOutError
        }
        mockCurrentUser = nil
    }
    
    func addStateDidChangeListener(_ listener: @escaping (MockAuthProtocol, MockUser?) -> Void) -> MockAuthStateDidChangeListenerHandle {
        stateChangeHandler = listener
        return MockAuthStateDidChangeListenerHandle()
    }
    
    func removeStateDidChangeListener(_ listener: MockAuthStateDidChangeListenerHandle) {
        stateChangeHandler = nil
    }
}

class MockUser {
    let uid: String
    let email: String?
    
    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
}

class MockAuthDataResult {
    let user: MockUser
    
    init(user: MockUser) {
        self.user = user
    }
}

class MockAuthStateDidChangeListenerHandle {
}
