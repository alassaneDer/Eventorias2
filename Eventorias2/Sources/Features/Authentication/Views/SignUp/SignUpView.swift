//
//  SignUpView2.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//

import SwiftUI
import PhotosUI

struct SignUpView: View {
    @StateObject var signUpViewModel: SignUpViewModel
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var sessionManager: SessionManager
    @Environment(\.self) private var env
    @State private var selectedPhoto: PhotosPickerItem?
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
                
                IconTextField(icon: .person, placeholder: "auth_placeholder_name", text: $signUpViewModel.username)
                
                IconTextField(icon: .envelope, placeholder: "auth_placeholder_email", text: $signUpViewModel.email)
                    .keyboardType(.emailAddress)
                
                SecureToggleField(placeholder: "auth_placeholder_password", text: $signUpViewModel.password, isSecured: $signUpViewModel.isSecured)
                
                SecureToggleField(placeholder: "auth_placeholder_confirmPassword", text: $signUpViewModel.confirmPassword, isSecured: $signUpViewModel.isConfirmSecured)
                
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Text("Select Profile Picture")
                        .foregroundStyle(Color.primary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 4)
                                .foregroundStyle(Color.background_field(env))
                        }
                }
                .onChange(of: selectedPhoto) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            signUpViewModel.profilePictureData = data
                        }
                    }
                }
                
                if let data = signUpViewModel.profilePictureData, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
                
                AuthButtonLabel(titleLabel: "auth_button_signUp") {
                    Task {
                        await signUpViewModel.signUp()
                        if signUpViewModel.errorMessage == nil {
                            navigateToRoute = .main(.eventList)
                        }
                    }
                }
                .padding(.top)
                .disabled(signUpViewModel.isLoading || !signUpViewModel.isFormValid)
                .overlay {
                    if signUpViewModel.isLoading {
                        ProgressView()
                    }
                }
                
                Spacer()
                
                BottomAuthPrompt(text: "auth_button_already_have_account", actionText: "auth_button_signIn") {
                    navigateToRoute = .auth(.signIn)
                }
            }
            .padding()
            
            if let errorMessage = signUpViewModel.errorMessage {
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
                        Text(NSLocalizedString("auth_button_signUp", comment: "Sign Up"))
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

struct SignUpView2_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        SignUpView(signUpViewModel: dependencyContainer.makeSignUpViewModel())
            .environmentObject(dependencyContainer.sessionManager)
            .environmentObject(dependencyContainer.makeNavigationCoordinator())
    }
}
