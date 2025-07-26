//
//  EventListViewModel.swift
//  Eventorias2
//
//  Created by Alassane Der on 15/07/2025.
//
import Foundation
import Combine

class EventListViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var users: [String: AuthUser] = [:]
    @Published var errorMessage: IdentifiableError?
    @Published var searchable: String = ""
    @Published var sortBy: sortOption = .dateAscending
    
    enum sortOption {
        case dateAscending
        case dateDescending
        case title
    }
    
    private let eventService: EventServiceProtocol
    private let userService: UserServiceProtocol
    
    init(eventService: EventServiceProtocol = EventService(), userService: UserServiceProtocol = UserService()) {
        self.eventService = eventService
        self.userService = userService
    }
    
    var filteredEvents: [Event] {
        var result = events
        
        if !searchable.isEmpty {
            let searchLowercased = searchable.lowercased()
            result = result.filter {
                $0.title.lowercased().contains(searchLowercased) ||
                ($0.description?.lowercased().contains(searchLowercased) ?? false) ||
                "\($0.location.latitude), \($0.location.longitude)".contains(searchLowercased)
            }
        }
        
        switch sortBy {
        case .dateAscending:
            return result.sorted { $0.date < $1.date }
        case .dateDescending:
            return result.sorted { $0.date > $1.date }
        case .title:
            return result.sorted { $0.title.lowercased() < $1.title.lowercased() }
        }
    }
    
    func toggleSort() {
        switch sortBy {
        case .dateAscending:
            sortBy = .dateDescending
        case .dateDescending:
            sortBy = .title
        case .title:
            sortBy = .dateAscending
        }
    }
    
    @MainActor
    func fetchEvents() async {
        do {
            let fetchedEvents = try await eventService.fetchEvents()
            self.events = fetchedEvents
            print("Events fetched: \(fetchedEvents.map { ($0.title, $0.imageUrl ?? "nil") })")
            let userIds = Set(events.map { $0.ownerId })
            self.users = try await userService.fetchUsers(forIds: Array(userIds))
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            errorMessage = IdentifiableError(message: error.localizedDescription)
        }
    }
}
