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
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Bienvenue sur Eventorias")
                .font(.largeTitle)
                .accessibilityLabel("Écran d'accueil d'Eventorias")
            
            Text("Organisez et découvrez des événements incroyables !")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .accessibilityLabel("Description de l'application")
            
            Button(action: {
                coordinator.push(.signUp)
            }) {
                Text("S'inscrire")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .accessibilityLabel("Aller à l'inscription")
            .accessibilityHint("Appuyez pour créer un nouveau compte")
            
            Button(action: {
                coordinator.push(.signIn)
            }) {
                Text("Se connecter")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 1)
                    )
            }
            .accessibilityLabel("Aller à la connexion")
            .accessibilityHint("Appuyez pour vous connecter à un compte existant")
        }
        .padding()
        .navigationTitle("Eventorias")
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
