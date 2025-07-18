//
//  EventServiceProtocol.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//

import Foundation

protocol EventServiceProtocol {
    func fetchEvents() async throws -> [Event]
    func createEvent(_ event: Event, imageData: Data?) async throws
    func fetchEvent(id: String) async throws -> Event
    func uploadEventImage(_ data: Data, forEventId: String) async throws -> String
}
