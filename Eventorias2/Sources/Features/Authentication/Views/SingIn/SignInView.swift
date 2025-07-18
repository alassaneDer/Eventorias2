//
//  SignInView2.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//

import SwiftUI

struct SignInView: View {
    @StateObject var signInViewmodel: SignInViewModel
    
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var sessionManager: SessionManager
    
    @Environment(\.self) private var env
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
            Color.background(env)
                .ignoresSafeArea(.all)
            
            VStack {
                VStack (spacing: 32) {
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
                
                /// FORM
                
                IconTextField(icon: .envelope, placeholder: "auth_placeholder_email", text: $signInViewmodel.email)
                
                SecureToggleField(placeholder: "auth_placeholder_password", text: $signInViewmodel.password, isSecured: $signInViewmodel.isSecured)
                
                HStack {
                    Spacer()
                    
                    BottomAuthPrompt(text: "auth_button_forgot_password", actionText: "auth_button_resset_password") {
                        /// Navigate to resset password view
                    }
                }
                .padding()
                
                AuthButtonLabel(titleLabel: "auth_button_signIn") {
                    /// call the login method in the VM
                    Task {
                        await signInViewmodel.signIn()
                        if signInViewmodel.errorMessage == nil {
                            coordinator.push(.eventList)
                        }
                    }
                }
                .disabled(signInViewmodel.isLoading || !signInViewmodel.isFormValid)
                .overlay {
                    if signInViewmodel.isLoading {
                        ProgressView()
                    }
                }
                
                Spacer()
                
                BottomAuthPrompt(text: "auth_button_no_account", actionText: "auth_button_signUp") {
                    coordinator.push(.signUp)
                }
                
            }
            .padding()
            
            if let errorMessage = signInViewmodel.errorMessage {
                Text(errorMessage)
                    .font(.custom("Inter-Regular", size: 16))
                    .foregroundStyle(Color(hex: "#D0021B"))
                    .padding()
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .animation(.easeInOut(duration: 0.3), value: errorMessage)
            }
        })
    }
}

struct SignInView2_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        SignInView(signInViewmodel: dependencyContainer.makeSignInViewModel())
            .environmentObject(dependencyContainer.sessionManager)
            .environmentObject(dependencyContainer.makeNavigationCoordinator())
    }
}
