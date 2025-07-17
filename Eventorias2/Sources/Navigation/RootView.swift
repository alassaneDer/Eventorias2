//
//  RootView.swift
//  Eventorias2
//
//  Created by Alassane Der on 15/07/2025.
//
import SwiftUI
import SwiftUI
import SwiftUI

struct RouteView: View {
    let route: Route
    let dependencyContainer: DependencyContainer
    
    init(route: Route, dependencyContainer: DependencyContainer) {
        self.route = route
        self.dependencyContainer = dependencyContainer
    }
    
    var body: some View {
        switch route {
        case .signUp:
            SignUpView(viewModel: dependencyContainer.makeSignUpViewModel())
        case .signIn:
            SignInView(viewModel: dependencyContainer.makeSignInViewModel())
        case .eventList:
            EventListView(viewModel: dependencyContainer.makeEventListViewModel())
        case .main:
            MainView()
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
