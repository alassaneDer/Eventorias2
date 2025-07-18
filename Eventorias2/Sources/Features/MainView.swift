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
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
            Color.background(env)
                .ignoresSafeArea()
            
            VStack {
                VStack(spacing: 32) {
                    Image("Logo")
                        .renderingMode(.template)
                        .imageScale(.large)
                        .accessibilityHidden(true)
                    
                    Image("Eventorias")
                        .renderingMode(.template)
                        .imageScale(.large)
                        .padding(.bottom)
                        .accessibilityLabel(NSLocalizedString("image_logo_accessibility", comment: "Accessibility label for Eventorias logo"))

                }
                .padding(.top, 80)
                .padding(.bottom, 50)

                Text(NSLocalizedString("subtitle_app_description", comment: "Organize and discover amazing events!"))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(8)
                    .accessibilityLabel(NSLocalizedString("accessibility_app_description", comment: "Accessibility label for Eventorias logo"))                
                Button {
                    coordinator.push(.signIn)
                } label: {
                    HStack(spacing: 20) {
                        Image("EnvelopeIcon")
                        
                        Text(NSLocalizedString("button_signIn_with_email_title", comment: "Sign in with email button title"))
                            .foregroundStyle(Color.primary)
                            .font(.custom("Inter-Regular", size: 20))
                            .fontWeight(.bold)
                            .padding(.trailing)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(Color(hex: "#D0021B"))
                    }
                }
                .accessibilityLabel(NSLocalizedString("button_signIn_with_email_description", comment: "signIn with email description"))
                .accessibilityHint(NSLocalizedString("button_signIn_with_email_action", comment: "signIn with email action"))

                Button {
                    coordinator.push(.signUp)
                } label: {
                    HStack(spacing: 20) {
                        Image("EnvelopeIcon")
                        
                        Text(NSLocalizedString("button_signUp_with_email_title", comment: "Sign up with email button title"))
                            .foregroundStyle(Color.primary)
                            .font(.custom("Inter-Regular", size: 20))
                            .fontWeight(.bold)
                            .padding(.trailing)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(Color.background_field(env))
                    }
                }
                .accessibilityLabel(NSLocalizedString("button_signUp_with_email_description", comment: "sign Up with email description"))
                .accessibilityHint(NSLocalizedString("button_signUp_with_email_action", comment: "sign up with email action"))
                
            }
            .padding(.horizontal)
        })
        
        
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
