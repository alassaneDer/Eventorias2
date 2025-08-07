//
//  EventCreateViewModel.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//

import Foundation
import MapKit

struct IdentifiableError: Identifiable, Equatable {
    let id = UUID()
    let message: String
}

struct LocationPoint: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

class EventCreateViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var address: String = ""
    @Published var date: Date = Date()
    @Published var imageData: Data?
    @Published var errorMessage: IdentifiableError?
    @Published var isLoading: Bool = false
    
    private let eventService: EventServiceProtocol
    private let geocodingService: GeocodingServiceProtocol
    
    init(eventService: EventServiceProtocol = EventService(), geocodingService: GeocodingServiceProtocol = GeocodingService()) {
        self.eventService = eventService
        self.geocodingService = geocodingService
    }
    
    var isFormValid: Bool {
        !title.isEmpty &&
        !address.isEmpty &&
        date >= Date()
    }
    
    func updateDate(dayPart: Date? = nil, timePart: Date? = nil) {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self.date)
        
        if let day = dayPart {
            let dayComponents = calendar.dateComponents([.year, .month, .day], from: day)
            components.year = dayComponents.year
            components.month = dayComponents.month
            components.day = dayComponents.day
        }
        
        if let time = timePart {
            let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
            components.hour = timeComponents.hour
            components.minute = timeComponents.minute
        }
        
        if let newDate = calendar.date(from: components) {
            self.date = newDate
        }
    }
    
    @MainActor
    func createEvent(ownerId: String) async {
        print("Creating event: title=\(title), ownerId=\(ownerId), address=\(address), imageData=\(imageData?.count ?? 0) bytes)")
        guard isFormValid else {
            errorMessage = IdentifiableError(message: NSLocalizedString("event_error_invalid_form", comment: "Invalid form input"))
            print("Form validation failed")
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let coordinates = try await geocodingService.geocodeAddress(address)
            let location = coordinates.map { Event.Location(latitude: $0.latitude, longitude: $0.longitude) } ?? Event.Location(latitude: 0, longitude: 0)
            
            let event = Event(
                id: nil,
                title: title,
                description: description.isEmpty ? nil : description,
                address: address,
                date: date,
                ownerId: ownerId,
                imageUrl: nil,
                location: location
            )
            
            try await eventService.createEvent(event, imageData: imageData)
            print("Event created successfully")
            clearForm()
        } catch {
            print("Error creating event: \(error.localizedDescription)")
            errorMessage = IdentifiableError(message: error.localizedDescription)
        }
    }
    
    private func clearForm() {
        title = ""
        description = ""
        address = ""
        date = Date()
        imageData = nil
        print("Form cleared")
    }
}
