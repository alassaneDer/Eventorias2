//
//  EventDetailViewModel.swift
//  Eventorias2
//
//  Created by Alassane Der on 24/07/2025.
//

import Foundation
import MapKit

@MainActor
class EventDetailViewModel: ObservableObject {
    @Published var event: Event?
    @Published var errorMessage: IdentifiableError?
    @Published var region: MKCoordinateRegion
    
    private let eventId: String
    private let eventService: EventServiceProtocol
    private let geocodingService: GeocodingServiceProtocol
    
    init(eventId: String, eventService: EventServiceProtocol = EventService(), geocodingService: GeocodingServiceProtocol = GeocodingService()) {
        self.eventId = eventId
        self.eventService = eventService
        self.geocodingService = geocodingService
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }
    
    @MainActor
    func fetchEvent() async {
        do {
            let fetchedEvent = try await eventService.fetchEvent(id: eventId)
            self.event = fetchedEvent
            await updateRegion()
        } catch {
            print("Error fetching event: \(error.localizedDescription)")
            errorMessage = IdentifiableError(message: error.localizedDescription)
        }
    }
    
    @MainActor
    func deleteEvent() async {
        guard let eventId = event?.id else { return }
        do {
            try await eventService.deleteEvent(id: eventId)
        } catch {
            print("Error deleting event: \(error.localizedDescription)")
            errorMessage = IdentifiableError(message: error.localizedDescription)
        }
    }
    
    @MainActor
    private func updateRegion() async {
        guard let event = event else { return }
        
        if event.location.latitude != 0 && event.location.longitude != 0 {
            self.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        } else if let address = event.address, !address.isEmpty {
            do {
                if let coordinates = try await geocodingService.geocodeAddress(address) {
                    self.region = MKCoordinateRegion(
                        center: coordinates,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                }
            } catch {
                print("Error geocoding address in detail view: \(error.localizedDescription)")
                errorMessage = IdentifiableError(message: error.localizedDescription)
            }
        }
    }
}
