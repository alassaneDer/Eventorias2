//
//  NavigationCoordinator.swift
//  Eventorias2
//
//  Created by Alassane Der on 15/07/2025.
//
import Foundation
/// reenommer ScreenManager
@MainActor
class NavigationCoordinator: ObservableObject {
    @Published var path: [Route] = []
    /// Deux : 1 pour event et un pour profil, pourquoi pas deux coordinators
    let sessionManager: SessionManager
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
    
    func isUserAuthenticated() -> Bool {
        return sessionManager.isAuthenticated
    }
    
    func initialRoute() -> Route {
        return isUserAuthenticated() ? .eventList : .main
    }
}
