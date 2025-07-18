//
//  Eventorias2App.swift
//  Eventorias2
//
//  Created by Alassane Der on 12/07/2025.
//
import SwiftUI
import FirebaseCore

@main
struct EventoriasApp: App {
    @StateObject private var dependencyContainer: DependencyContainer
    @StateObject private var coordinator: NavigationCoordinator
    
    @MainActor
    init() {
        FirebaseApp.configure() // Configure Firebase avant d'instancier les dépendances
        let dependencyContainer = DependencyContainer()
        _dependencyContainer = StateObject(wrappedValue: dependencyContainer)
        _coordinator = StateObject(wrappedValue: dependencyContainer.makeNavigationCoordinator())
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                RouteView(route: coordinator.initialRoute(), dependencyContainer: dependencyContainer)
                    .navigationDestination(for: Route.self) { route in
                        RouteView(route: route, dependencyContainer: dependencyContainer)
                    }
            }
            .environmentObject(coordinator)
            .environmentObject(dependencyContainer.sessionManager)
        }
    }
}
