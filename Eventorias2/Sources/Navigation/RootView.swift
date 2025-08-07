//
//  RootView.swift
//  Eventorias2
//
//  Created by Alassane Der on 15/07/2025.
//
//
import SwiftUI

struct RouteView: View {
    let route: Route
    let dependencyContainer: DependencyContainer
    
    var body: some View {
        switch route {
        case .auth(.main):
            MainView()
                .environmentObject(dependencyContainer.sessionManager)
        case .auth(.signUp):
            SignUpView(signUpViewModel: dependencyContainer.makeSignUpViewModel())
                .environmentObject(dependencyContainer.sessionManager)
        case .auth(.signIn):
            SignInView(signInViewModel: dependencyContainer.makeSignInViewModel())
                .environmentObject(dependencyContainer.sessionManager)
        case .main(.eventList):
            EventListView(viewModel: dependencyContainer.makeEventListViewModel())
                .environmentObject(dependencyContainer.sessionManager)
        case .main(.eventCreate):
            EventCreateView(viewModel: dependencyContainer.makeEventCreateViewModel())
                .environmentObject(dependencyContainer.sessionManager)
        case .main(.userProfile):
            UserProfileView()
                .environmentObject(dependencyContainer.sessionManager)
        case .main(.eventDetail(let eventId)):
            EventDetailView(viewModel: dependencyContainer.makeEventDetailViewModel(eventId: eventId))
                .environmentObject(dependencyContainer.sessionManager)
        }
    }
}

struct RouteView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        RouteView(route: .auth(.main), dependencyContainer: dependencyContainer)
            .environmentObject(dependencyContainer.sessionManager)
            .environmentObject(dependencyContainer.makeNavigationCoordinator())
    }
}
