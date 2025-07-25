//
//  EventDetailViewModel.swift
//  Eventorias2
//
//  Created by Alassane Der on 24/07/2025.
//

import Foundation

@MainActor
class EventDetailViewModel: ObservableObject {
    @Published var event: Event?
    @Published var errorMessage: IdentifiableError?
    
    private let eventService: EventServiceProtocol
    private let eventId: String
    
    init(eventService: EventServiceProtocol = EventService(), eventId: String) {
        self.eventService = eventService
        self.eventId = eventId
    }
    
    func fetchEvent() async {
        do {
            event = try await eventService.fetchEvent(id: eventId)
        } catch {
            errorMessage = IdentifiableError(message: error.localizedDescription)
        }
    }
    
    func deleteEvent() async {
        do {
            try await eventService.deleteEvent(id: eventId)
            event = nil
        } catch {
            errorMessage = IdentifiableError(message: error.localizedDescription)
        }
    }
}
