//
//  Event.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//

import FirebaseFirestore
import Foundation

struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    let title: String
    let description: String?
    let address: String?
    let date: Date
    let ownerId: String
    let imageUrl: String?
    let location: Location
    
    struct Location: Codable {
        let latitude: Double
        let longitude: Double
    }
    
    static let sample: [Event] = [
        Event(id: "sample1", title: "Sample Event", description: "This is a sample event", address: "Sample Address", date: Date(), ownerId: "sampleUserId", imageUrl: "https://via.placeholder.com/136x80", location: Location(latitude: 48.8566, longitude: 2.3522))
    ]
}

/*
struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    let title: String
    let description: String
    let date: Date
    let ownerId: String
    let imageUrl: String?
    let location: Location
    
    struct Location: Codable {
        let latitude: Double
        let longitude: Double
    }
}


extension Event {
    static let sample: [Event] = [
        Event(title: "Music Festival", description: "event have not description for now", date: Date(), ownerId: "Jonh", imageUrl: "pexels1", location: Location(latitude: 1.0, longitude: 2.0)),
        Event(title: "Music Festival", description: "event have not description for now", date: Date(), ownerId: "Jonh", imageUrl: "pexels1", location: Location(latitude: 1.0, longitude: 2.0)),
        Event(title: "Music Festival", description: "event have not description for now", date: Date(), ownerId: "Jonh", imageUrl: "pexels1", location: Location(latitude: 1.0, longitude: 2.0)),
        Event(title: "Music Festival", description: "event have not description for now", date: Date(), ownerId: "Jonh", imageUrl: "pexels1", location: Location(latitude: 1.0, longitude: 2.0))
    ]
}
*/
