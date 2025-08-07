//
//  ContentView.swift
//  Eventorias2
//
//  Created by Alassane Der on 12/07/2025.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var sessionManager: SessionManager
    @Environment(\.self) private var env
    @State private var navigateToRoute: Route?

    var body: some View {
        ZStack {
            Color.background(env)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 32) {
                Image("Logo")
                    .renderingMode(.template)
                    .imageScale(.large)
                
                Image("Eventorias")
                    .renderingMode(.template)
                    .imageScale(.large)
                
                Spacer()
                
                AuthButtonLabel(titleLabel: "auth_button_signIn") {
                    navigateToRoute = .auth(.signIn)
                }
                
                AuthButtonLabel(titleLabel: "auth_button_signUp") {
                    navigateToRoute = .auth(.signUp)
                }
                
                Spacer()
            }
            .padding()
        }
        .task(id: navigateToRoute) {
            if let route = navigateToRoute {
                coordinator.push(route)
                navigateToRoute = nil
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        MainView()
            .environmentObject(dependencyContainer.sessionManager)
            .environmentObject(dependencyContainer.makeNavigationCoordinator())
    }
}
