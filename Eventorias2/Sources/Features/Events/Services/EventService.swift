//
//  EventService.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//

import FirebaseFirestore
import FirebaseStorage
import Foundation
import UIKit

class EventService: EventServiceProtocol {
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    func fetchEvents() async throws -> [Event] {
        do {
            let snapshot = try await db.collection("events").getDocuments()
            let events = try snapshot.documents.map { try $0.data(as: Event.self) }
            print("Fetched \(events.count) events from Firestore: \(events.map { ($0.id ?? "nil", $0.title, $0.imageUrl ?? "no image") })")
            return events
        } catch {
            print("Error fetching events: \(error.localizedDescription)")
            throw EventErrors.fetchFailed(error)
        }
    }
    
    func createEvent(_ event: Event, imageData: Data?) async throws {
        let eventId = event.id ?? UUID().uuidString
        var updatedEvent = event
        
        do {
            if let imageData = imageData {
                let imageUrl = try await uploadEventImage(imageData, forEventId: eventId)
                print("Image uploaded for event \(eventId), URL: \(imageUrl)")
                updatedEvent = Event(id: eventId, title: event.title, description: event.description, address: event.address, date: event.date, ownerId: event.ownerId, imageUrl: imageUrl, location: event.location)
            } else {
                print("No image data provided for event \(eventId)")
            }
            
            let documentRef = db.collection("events").document(eventId)
            try await documentRef.setData(from: updatedEvent)
            print("Event created: \(eventId), title: \(event.title), imageUrl: \(updatedEvent.imageUrl ?? "none")")
        } catch {
            print("Error creating event \(eventId): \(error.localizedDescription)")
            throw EventErrors.createFailed(error)
        }
    }
    
    func fetchEvent(id: String) async throws -> Event {
        do {
            let document = try await db.collection("events").document(id).getDocument()
            guard document.exists else {
                print("Event not found: id=\(id)")
                throw EventErrors.eventNotFound
            }
            let event = try document.data(as: Event.self)
            print("Fetched event: id=\(id), title=\(event.title)")
            return event
        } catch {
            print("Error fetching event \(id): \(error.localizedDescription)")
            throw EventErrors.fetchFailed(error)
        }
    }
    
    func uploadEventImage(_ data: Data, forEventId: String) async throws -> String {
        let imageRef = storage.child("eventImages/\(forEventId)/event.jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let compressedData = UIImage(data: data)?.jpegData(compressionQuality: 0.8) ?? data
        print("Uploading image for event \(forEventId), original size: \(data.count) bytes, compressed size: \(compressedData.count) bytes")
        
        do {
            _ = try await imageRef.putDataAsync(compressedData, metadata: metadata)
            let downloadURL = try await imageRef.downloadURL()
            print("Image upload successful, URL: \(downloadURL.absoluteString)")
            return downloadURL.absoluteString
        } catch {
            print("Image upload failed for event \(forEventId): \(error.localizedDescription)")
            throw EventErrors.uploadImageFailed(error)
        }
    }
    
    func deleteEvent(id: String) async throws {
        do {
            try await db.collection("events").document(id).delete()
            let imageRef = storage.child("eventImages/\(id)/event.jpg")
            do {
                try await imageRef.delete()
                print("Image deleted for event \(id)")
            } catch {
                print("Failed to delete image for event \(id): \(error.localizedDescription)")
            }
            print("Event deleted: id=\(id)")
        } catch {
            print("Error deleting event \(id): \(error.localizedDescription)")
            throw EventErrors.deleteFailed(error)
        }
    }
}

enum EventErrors: Error, LocalizedError {
    case eventNotFound
    case fetchFailed(Error)
    case createFailed(Error)
    case uploadImageFailed(Error)
    case deleteFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .eventNotFound:
            return NSLocalizedString("event_error_not_found", comment: "Event not found")
        case .fetchFailed(let error):
            return NSLocalizedString("event_error_fetch_failed", comment: "Failed to fetch events: \(error.localizedDescription)")
        case .createFailed(let error):
            return NSLocalizedString("event_error_create_failed", comment: "Failed to create event: \(error.localizedDescription)")
        case .uploadImageFailed(let error):
            return NSLocalizedString("event_error_upload_image_failed", comment: "Failed to upload image: \(error.localizedDescription)")
        case .deleteFailed(let error):
            return NSLocalizedString("event_error_delete_failed", comment: "Failed to delete event: \(error.localizedDescription)")
        }
    }
}
