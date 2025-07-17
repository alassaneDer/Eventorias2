//
//  EventListView.swift
//  Eventorias2
//
//  Created by Alassane Der on 15/07/2025.
//
import SwiftUI

struct EventListView: View {
    @StateObject private var viewModel: EventListViewModel
    @EnvironmentObject private var coordinator: NavigationCoordinator
    
    init(viewModel: EventListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List(viewModel.events, id: \.self) { event in
            Text(event)
                .accessibilityLabel("Événement : \(event)")
        }
        .navigationTitle("Événements")
        .onAppear {
            viewModel.fetchEvents()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Déconnexion") {
                    Task {
                        do {
                            try await coordinator.sessionManager.signOut()
                            coordinator.popToRoot()
                        } catch {
                            // Gérer l'erreur de déconnexion (ex. afficher une alerte)
                        }
                    }
                }
                .accessibilityLabel("Se déconnecter")
            }
        }
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        EventListView(viewModel: dependencyContainer.makeEventListViewModel())
            .environmentObject(dependencyContainer.makeNavigationCoordinator())
    }
}
