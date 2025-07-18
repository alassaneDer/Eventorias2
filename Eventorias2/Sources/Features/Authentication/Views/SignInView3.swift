//
//  SignInView.swift
//  Eventorias2
//
//  Created by Alassane Der on 15/07/2025.
//
import SwiftUI

struct SignInView3: View {
    @StateObject private var viewModel: SignInViewModel
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var sessionManager: SessionManager
    
    init(viewModel: SignInViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Connexion")
                .font(.largeTitle)
                .accessibilityLabel("Connexion à Eventorias")
            
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .accessibilityLabel("Adresse email")
            
            SecureField("Mot de passe", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)
                .accessibilityLabel("Mot de passe")
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .accessibilityLabel("Erreur : \(errorMessage)")
            }
            
            Button(action: {
                Task {
                    await viewModel.signIn()
                    if viewModel.errorMessage == nil {
                        coordinator.push(.eventList)
                    }
                }
            }) {
                Text("Se connecter")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isLoading ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(viewModel.isLoading || !viewModel.isFormValid)
            .accessibilityLabel("Bouton de connexion")
            .accessibilityHint("Appuyez pour vous connecter")
            
            Button("Pas de compte ? Inscrivez-vous") {
                coordinator.push(.signUp)
            }
            .accessibilityLabel("Aller à l'inscription")
        }
        .padding()
        .navigationTitle("Connexion")
        .environmentObject(sessionManager)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        SignInView3(viewModel: dependencyContainer.makeSignInViewModel())
            .environmentObject(dependencyContainer.sessionManager)
            .environmentObject(dependencyContainer.makeNavigationCoordinator())
    }
}
