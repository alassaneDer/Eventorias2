//
//  AuthServiceTests.swift
//  Eventorias2Tests
//
//  Created by Alassane Der on 01/08/2025.
//
//
import Foundation
@testable import Eventorias2
import Firebase

// Protocole pour simuler Firestore
protocol MockFirestoreProtocol {
    func collection(_ collectionPath: String) -> MockCollectionReference
}

protocol MockCollectionReferenceProtocol {
    func document(_ documentPath: String) -> MockDocumentReference
}

protocol MockDocumentReferenceProtocol {
    func getDocument() async throws -> MockDocumentSnapshot
    func setData(from data: Encodable) async throws
}

class MockFirestore: MockFirestoreProtocol {
    var mockDocuments: [String: MockDocumentSnapshot] = [:]
    var setDataError: Error?
    
    func collection(_ collectionPath: String) -> MockCollectionReference {
        MockCollectionReference(firestore: self, path: collectionPath)
    }
}

class MockCollectionReference: MockCollectionReferenceProtocol {
    let firestore: MockFirestore
    let path: String
    
    init(firestore: MockFirestore, path: String) {
        self.firestore = firestore
        self.path = path
    }
    
    func document(_ documentPath: String) -> MockDocumentReference {
        MockDocumentReference(firestore: firestore, path: "\(path)/\(documentPath)")
    }
}

class MockDocumentReference: MockDocumentReferenceProtocol {
    let firestore: MockFirestore
    let path: String
    
    init(firestore: MockFirestore, path: String) {
        self.firestore = firestore
        self.path = path
    }
    
    func getDocument() async throws -> MockDocumentSnapshot {
        if let document = firestore.mockDocuments[path] {
            return document
        }
        throw NSError(domain: "MockFirestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])
    }
    
    func setData(from data: Encodable) async throws {
        if let setDataError = firestore.setDataError {
            throw setDataError
        }
        let encoder = Firestore.Encoder()
        let encodedData = try encoder.encode(data)
        firestore.mockDocuments[path] = MockDocumentSnapshot(data: encodedData)
    }
}

class MockDocumentSnapshot {
    let data: [String: Any]?
    
    init(data: [String: Any]?) {
        self.data = data
    }
    
    func exists() -> Bool {
        data != nil
    }
    
    func data(as type: Decodable.Type) throws -> Decodable {
        guard let data else {
            throw NSError(domain: "MockFirestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])
        }
        let decoder = Firestore.Decoder()
        return try decoder.decode(type, from: data)
    }
}
