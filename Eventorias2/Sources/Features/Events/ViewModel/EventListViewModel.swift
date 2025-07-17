//
//  EventListViewModel.swift
//  Eventorias2
//
//  Created by Alassane Der on 15/07/2025.
//

import Foundation

@MainActor
class EventListViewModel: ObservableObject {
    @Published var events: [String] = []
    
    func fetchEvents() {
        // À implémenter dans la prochaine étape
        events = ["Événement 1", "Événement 2", "Événement 3"]
    }
}
