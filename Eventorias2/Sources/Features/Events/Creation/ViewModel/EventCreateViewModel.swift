//
//  EventCreateViewModel.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//
import Foundation
import MapKit

@MainActor
class EventCreateViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var address: String = ""
    @Published var date: Date = Date()
    @Published var latitude: String = ""
    @Published var longitude: String = ""
    @Published var imageData: Data?
    @Published var errorMessage: IdentifiableError?
    @Published var isLoading: Bool = false
    
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @Published var selectedLocation: LocationPoint = LocationPoint(coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522))
    
    private let eventService: EventServiceProtocol
    
    init(eventService: EventServiceProtocol = EventService()) {
        self.eventService = eventService
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
    
    func updateLocation(coordinate: CLLocationCoordinate2D) {
        selectedLocation = LocationPoint(coordinate: coordinate)
        latitude = String(format: "%.6f", coordinate.latitude)
        longitude = String(format: "%.6f", coordinate.longitude)
        mapRegion.center = coordinate
        print("Location updated: latitude=\(latitude), longitude=\(longitude)")
    }
    
    var isFormValid: Bool {
        guard let lat = Double(latitude), let lon = Double(longitude) else {
            return false
        }
        return !title.isEmpty &&
               !description.isEmpty &&
               !latitude.isEmpty &&
               !longitude.isEmpty &&
               lat >= -90 && lat <= 90 &&
               lon >= -180 &&
               lon <= 180 &&
               date >= Date()
    }
    
    func createEvent(ownerId: String) async {
        print("Creating event: title=\(title), ownerId=\(ownerId), imageData=\(imageData?.count ?? 0) bytes)")
        guard isFormValid else {
            errorMessage = IdentifiableError(message: NSLocalizedString("event_error_invalid_form", comment: "Invalid form input"))
            print("Form validation failed")
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let location = Event.Location(latitude: Double(latitude) ?? 0.0, longitude: Double(longitude) ?? 0.0)
            let event = Event(id: nil, title: title, description: description, address: address, date: date, ownerId: ownerId, imageUrl: nil, location: location)
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
        latitude = ""
        longitude = ""
        imageData = nil
        mapRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        selectedLocation = LocationPoint(coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522))
        print("Form cleared")
    }
}

struct IdentifiableError: Identifiable, Equatable {
    let id = UUID()
    let message: String
}

struct LocationPoint: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
