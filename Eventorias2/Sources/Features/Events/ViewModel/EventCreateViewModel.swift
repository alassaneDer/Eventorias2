//
//  EventCreateViewModel.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//

import Foundation

@MainActor
class EventCreateViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var date: Date = Date()
    @Published var latitude: String = ""
    @Published var longitude: String = ""
    @Published var imageData: Data?
    @Published var errorMessage: IdentifiableError?
    @Published var isLoading: Bool = false
    
    private let eventService: EventServiceProtocol
    
    init(eventService: EventServiceProtocol = EventService()) {
        self.eventService = eventService
    }
    
    func updateDate(dayPart: Date? = nil, timePart: Date? = nil) {
        var calendar = Calendar.current
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
    
    var isFormValid: Bool {
        !title.isEmpty && 
        !description.isEmpty && 
        !latitude.isEmpty && 
        !longitude.isEmpty &&
        Double(latitude) != nil &&
        Double(longitude) != nil &&
        date >= Date()
    }
    
    func createEvent(ownerId: String) async {
        guard isFormValid else {
            errorMessage = IdentifiableError(message: NSLocalizedString("event_error_invalid_form", comment: "Invalid form input"))
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let location = Event.Location(latitude: Double(latitude) ?? 0.0, longitude: Double(longitude) ?? 0.0)
            let event = Event(id: nil, title: title, description: description, date: date, ownerId: ownerId, imageUrl: nil, location: location)
            try await eventService.createEvent(event, imageData: imageData)
            clearForm()
        } catch {
            errorMessage = IdentifiableError(message: error.localizedDescription)
        }
    }
    
    private func clearForm() {
        title = ""
        description = ""
        date = Date()
        latitude = ""
        longitude = ""
        imageData = nil
    }
    
}

struct IdentifiableError: Identifiable {
    let id = UUID()
    let message: String
}
