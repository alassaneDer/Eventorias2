//
//  EventService.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//

import FirebaseFirestore
import FirebaseStorage
import Foundation

class EventService: EventServiceProtocol {
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    func fetchEvents() async throws -> [Event] {
        let snapshot = try await db.collection("events").getDocuments()
        return try snapshot.documents.map { try $0.data(as: Event.self) }
    }
    
    func createEvent(_ event: Event, imageData: Data?) async throws {
        let eventId = event.id ?? UUID().uuidString
        var updatedEvent = event
        if let imageData = imageData {
            let imageUrl = try await uploadEventImage(imageData, forEventId: eventId)
            updatedEvent = Event(id: eventId, title: event.title, description: event.description, date: event.date, ownerId: event.ownerId, imageUrl: imageUrl, location: event.location)
        }
        try db.collection("events").document(eventId).setData(from: updatedEvent)
        print("Event created: \(eventId), imageUrl: \(updatedEvent.imageUrl ?? "none")")
    }
    
    func fetchEvent(id: String) async throws -> Event {
        let document = try await db.collection("events").document(id).getDocument()
        guard document.exists else {
            throw EventErrors.eventNotFound
        }
        return try document.data(as: Event.self)
    }
    
    func uploadEventImage(_ data: Data, forEventId: String) async throws -> String {
        let imageRef = storage.child("eventImages/\(forEventId)/event.jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        _ = try await imageRef.putDataAsync(data, metadata: metadata)
        let downloadURL = try await imageRef.downloadURL()
        return downloadURL.absoluteString
    }
    
    func deleteEvent(id: String) async throws {
        try await db.collection("events").document(id).delete()
        let imageRef = storage.child("eventImages/\(id)/event.jpg")
        try await imageRef.delete()
        print("Event deleted: \(id)")
    }
}
