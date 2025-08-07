//
//  Eventorias2App.swift
//  Eventorias2
//
//  Created by Alassane Der on 12/07/2025.
//
//

import SwiftUI
import FirebaseCore

@main
struct EventoriasApp: App {
    @StateObject private var dependencyContainer: DependencyContainer
    @StateObject private var coordinator: NavigationCoordinator
    
    @MainActor
    init() {
        FirebaseApp.configure()
        let dependencyContainer = DependencyContainer()
        _dependencyContainer = StateObject(wrappedValue: dependencyContainer)
        _coordinator = StateObject(wrappedValue: dependencyContainer.makeNavigationCoordinator())
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                Group {
                    if coordinator.isUserAuthenticated() {
                        NavigationStack(path: $coordinator.mainPath) {
                            RouteView(route: .main(.eventList), dependencyContainer: dependencyContainer)
                                .navigationDestination(for: MainRoute.self) { mainRoute in
                                    RouteView(route: .main(mainRoute), dependencyContainer: dependencyContainer)
                                }
                        }
                    } else {
                        NavigationStack(path: $coordinator.authPath) {
                            RouteView(route: .auth(.main), dependencyContainer: dependencyContainer)
                                .navigationDestination(for: AuthRoute.self) { authRoute in
                                    RouteView(route: .auth(authRoute), dependencyContainer: dependencyContainer)
                                }
                        }
                    }
                }
            }
            .environmentObject(coordinator)
            .environmentObject(dependencyContainer.sessionManager)
        }
    }
}
