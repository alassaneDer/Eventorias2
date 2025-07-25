//
//  RootView.swift
//  Eventorias2
//
//  Created by Alassane Der on 15/07/2025.
//

import SwiftUI

struct RouteView: View {
    let route: Route
    let dependencyContainer: DependencyContainer
    
    var body: some View {
        switch route {
        case .main:
            MainView()
                .environmentObject(dependencyContainer.sessionManager)
//                .environmentObject(dependencyContainer.makeNavigationCoordinator())
        case .signUp:
            SignUpView(signUpViewModel: dependencyContainer.makeSignUpViewModel())
                .environmentObject(dependencyContainer.sessionManager)
//                .environmentObject(dependencyContainer.makeNavigationCoordinator())
        case .signIn:
            SignInView(signInViewmodel: dependencyContainer.makeSignInViewModel())
                .environmentObject(dependencyContainer.sessionManager)
//                .environmentObject(dependencyContainer.makeNavigationCoordinator())
        case .eventList:
            EventListView()
                .environmentObject(dependencyContainer.sessionManager)
//                .environmentObject(dependencyContainer.makeNavigationCoordinator())
        case .eventCreate:
            EventCreateView()
                .environmentObject(dependencyContainer.sessionManager)
//                .environmentObject(dependencyContainer.makeNavigationCoordinator())
        case .userProfile:
            UserProfileView()
                .environmentObject(dependencyContainer.sessionManager)
//                .environmentObject(dependencyContainer.makeNavigationCoordinator())
        case .eventDetail(let eventId):
            EventDetailView(eventId: eventId)
                .environmentObject(dependencyContainer.sessionManager)
//                .environmentObject(dependencyContainer.makeNavigationCoordinator())
        }
    }
}

struct RouteView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        RouteView(route: .main, dependencyContainer: dependencyContainer)
            .environmentObject(dependencyContainer.sessionManager)
            .environmentObject(dependencyContainer.makeNavigationCoordinator())
    }
}
//#Preview {
//    RouteView()
//}
