//
//  NavigationCoordinator.swift
//  Eventorias2
//
//  Created by Alassane Der on 15/07/2025.
//
//
import Foundation
import SwiftUI

@MainActor
class NavigationCoordinator: ObservableObject {
    @Published var authPath: [AuthRoute] = []
    @Published var mainPath: [MainRoute] = []
    let sessionManager: SessionManager
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    func push(_ route: Route) {
        switch route {
        case .auth(let authRoute):
            authPath.append(authRoute)
        case .main(let mainRoute):
            mainPath.append(mainRoute)
        }
    }
    
    func push(_ route: AuthRoute) {
        authPath.append(route)
    }
    
    func push(_ route: MainRoute) {
        mainPath.append(route)
    }
    
    func popAuth() {
        authPath.removeLast()
    }
    
    func popMain() {
        mainPath.removeLast()
    }
    
    func popToRoot() {
        authPath.removeAll()
        mainPath.removeAll()
    }
    
    func isUserAuthenticated() -> Bool {
        return sessionManager.isAuthenticated
    }
    
    func initialRoute() -> Route {
        return isUserAuthenticated() ? .main(.eventList) : .auth(.main)
    }
}
