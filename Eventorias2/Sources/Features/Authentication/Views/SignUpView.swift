//
//  SignUpView.swift
//  Eventorias2
//
//  Created by Alassane Der on 15/07/2025.
//
import SwiftUI
import PhotosUI

struct SignUpView: View {
    @StateObject private var viewModel: SignUpViewModel
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var sessionManager: SessionManager
    @State private var selectedPhoto: PhotosPickerItem?
    
    init(viewModel: SignUpViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Inscription")
                .font(.largeTitle)
                .accessibilityLabel("Inscription à Eventorias")
            
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .accessibilityLabel("Adresse email")
            
            TextField("Nom d'utilisateur (optionnel)", text: $viewModel.username)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .accessibilityLabel("Nom d'utilisateur")
            
            SecureField("Mot de passe", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)
                .accessibilityLabel("Mot de passe")
            
            SecureField("Confirmer le mot de passe", text: $viewModel.confirmPassword)
                .textFieldStyle(.roundedBorder)
                .accessibilityLabel("Confirmation du mot de passe")
            
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                Text(viewModel.profilePictureData == nil ? "Choisir une photo de profil" : "Changer la photo de profil")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            .accessibilityLabel("Sélecteur de photo de profil")
            .accessibilityHint("Appuyez pour choisir une photo depuis votre bibliothèque")
            .onChange(of: selectedPhoto) { newItem, _ in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        viewModel.profilePictureData = data
                    }
                }
            }
            
            if let data = viewModel.profilePictureData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .accessibilityLabel("Aperçu de la photo de profil")
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .accessibilityLabel("Erreur : \(errorMessage)")
            }
            
            Button(action: {
                Task {
                    await viewModel.signUp()
                    if viewModel.errorMessage == nil {
                        coordinator.push(.eventList)
                    }
                }
            }) {
                Text("S'inscrire")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isLoading ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(viewModel.isLoading || !viewModel.isFormValid)
            .accessibilityLabel("Bouton d'inscription")
            .accessibilityHint("Appuyez pour créer un compte")
            
            Button("Déjà un compte ? Connectez-vous") {
                coordinator.push(.signIn)
            }
            .accessibilityLabel("Aller à la connexion")
        }
        .padding()
        .navigationTitle("Inscription")
        .environmentObject(sessionManager)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        SignUpView(viewModel: dependencyContainer.makeSignUpViewModel())
            .environmentObject(dependencyContainer.sessionManager)
            .environmentObject(dependencyContainer.makeNavigationCoordinator())
    }
}
