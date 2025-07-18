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
