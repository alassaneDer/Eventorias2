//
//  var createUserError: Error?.swift
//  Eventorias2Tests
//
//  Created by Alassane Der on 01/08/2025.
//

import FirebaseStorage
import Foundation
@testable import Eventorias2

// Protocole pour simuler Storage
protocol MockStorageReferenceProtocol {
    func child(_ path: String) -> MockStorageReference
    func putDataAsync(_ data: Data, metadata: StorageMetadata?) async throws -> StorageMetadata
    func downloadURL() async throws -> URL
}

class MockStorageReference: MockStorageReferenceProtocol {
    var mockDownloadURL: URL?
    var putDataError: Error?
    
    func child(_ path: String) -> MockStorageReference {
        MockStorageReference()
    }
    
    func putDataAsync(_ data: Data, metadata: StorageMetadata?) async throws -> StorageMetadata {
        if let putDataError {
            throw putDataError
        }
        return StorageMetadata()
    }
    
    func downloadURL() async throws -> URL {
        if let mockDownloadURL {
            return mockDownloadURL
        }
        throw NSError(domain: "MockStorage", code: -1, userInfo: [NSLocalizedDescriptionKey: "No download URL"])
    }
}
