//
//  SignInView2.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//
//
import SwiftUI

struct SignInView: View {
    @StateObject var signInViewModel: SignInViewModel
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var sessionManager: SessionManager
    @Environment(\.self) private var env
    @State private var navigateToRoute: Route?

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            Color.background(env)
                .ignoresSafeArea(.all)
            
            VStack {
                VStack(spacing: 32) {
                    Image("Logo")
                        .renderingMode(.template)
                        .imageScale(.large)
                    
                    Image("Eventorias")
                        .renderingMode(.template)
                        .imageScale(.large)
                        .padding(.bottom)
                }
                .padding(.top, 80)
                .padding(.bottom, 50)
                
                IconTextField(icon: .envelope, placeholder: "auth_placeholder_email", text: $signInViewModel.email)
                
                SecureToggleField(placeholder: "auth_placeholder_password", text: $signInViewModel.password, isSecured: $signInViewModel.isSecured)
                
                HStack {
                    Spacer()
                    BottomAuthPrompt(text: "auth_button_forgot_password", actionText: "auth_button_reset_password") {
                        // TODO: Ajouter navigation vers la vue de réinitialisation du mot de passe si nécessaire
                    }
                }
                .padding()
                
                AuthButtonLabel(titleLabel: "auth_button_signIn") {
                    Task {
                        await signInViewModel.signIn()
                        if signInViewModel.errorMessage == nil {
                            navigateToRoute = .main(.eventList)
                        }
                    }
                }
                .disabled(signInViewModel.isLoading || !signInViewModel.isFormValid)
                .overlay {
                    if signInViewModel.isLoading {
                        ProgressView()
                    }
                }
                
                Spacer()
                
                BottomAuthPrompt(text: "auth_button_no_account", actionText: "auth_button_signUp") {
                    navigateToRoute = .auth(.signUp)
                }
            }
            .padding()
            
            if let errorMessage = signInViewModel.errorMessage {
                Text(errorMessage)
                    .font(.custom("Inter-Regular", size: 16))
                    .foregroundStyle(Color(hex: "#D0021B"))
                    .padding()
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .animation(.easeInOut(duration: 0.3), value: errorMessage)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    navigateToRoute = .auth(.main)
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text(NSLocalizedString("auth_button_signIn", comment: "Sign In"))
                    }
                    .foregroundStyle(.primary)
                }
                .accessibilityLabel(NSLocalizedString("back_button_accessibility", comment: "Back to main"))
            }
        }
        .task(id: navigateToRoute) {
            if let route = navigateToRoute {
                if case .auth(.main) = route {
                    coordinator.popAuth()
                } else {
                    coordinator.push(route)
                }
                navigateToRoute = nil
            }
        }
    }
}

struct SignInView1_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        SignInView(signInViewModel: dependencyContainer.makeSignInViewModel())
            .environmentObject(dependencyContainer.sessionManager)
            .environmentObject(dependencyContainer.makeNavigationCoordinator())
    }
}
