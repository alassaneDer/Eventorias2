//
//  UserProfileView.swift
//  Eventorias2
//
//  Created by Alassane Der on 20/07/2025.
//
//
import SwiftUI
import PhotosUI

struct UserProfileView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var viewModel = UserProfileViewModel()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var notificationsEnabled = false
    @State private var showSignOutAlert = false
    @State private var navigateToRoute: Route?
    
    @Environment(\.self) private var env
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.background(env)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(NSLocalizedString("profile_title", comment: "User Profile"))
                        .font(.custom("Inter-Regular", size: 24))
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    if let user = viewModel.user {
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            AsyncImage(url: URL(string: user.profilePictureUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 48, height: 48)
                                    .clipShape(Circle())
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 48, height: 48)
                                    .foregroundStyle(Color.gray)
                            }
                        }
                        .onChange(of: selectedPhoto) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    await viewModel.uploadProfilePicture(data: data, forUserId: sessionManager.currentUser?.id ?? "")
                                }
                            }
                        }
                        .padding(.bottom)
                        .accessibilityLabel(NSLocalizedString("profile_change_photo", comment: "Change profile picture"))
                    }
                }
                
                ScrollView {
                    if let user = viewModel.user {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(NSLocalizedString("profile_name_title", comment: "name"))
                                .font(.custom("Inter-Regular", size: 14))
                                .foregroundStyle(Color.secondary)
                            Text(user.username ?? NSLocalizedString("profile_anonymous", comment: "Anonymous"))
                                .font(.custom("Inter-Regular", size: 16))
                                .foregroundStyle(Color.primary)
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 4.0).fill(Color.background_field(env)))
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text(NSLocalizedString("profile_email_title", comment: "email"))
                                .font(.custom("Inter-Regular", size: 14))
                                .foregroundStyle(Color.secondary)
                            Text(user.email)
                                .font(.custom("Inter-Regular", size: 16))
                                .foregroundStyle(Color.primary)
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 4.0).fill(Color.background_field(env)))
                        
                        HStack {
                            Toggle("", isOn: $notificationsEnabled)
                                .tint(Color(hex: "#D0021B"))
                                .labelsHidden()
                            
                            Text(NSLocalizedString("user_notification_enable", comment: "Enable notifications"))
                                .font(.custom("Inter-Regular", size: 16))
                                .foregroundStyle(Color.primary)
                            
                            Spacer()
                        }
                        .padding(.top)
                        .accessibilityLabel(NSLocalizedString("user_notification_toggle", comment: "Toggle notifications"))
                        
                        Button(action: {
                            showSignOutAlert = true
                        }, label: {
                            Text(NSLocalizedString("profile_button_signOut", comment: "Sign Out"))
                                .font(.custom("Inter-Regular", size: 16))
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(hex: "#D0021B"))
                                )
                        })
                        .padding(.top)
                        .accessibilityLabel(NSLocalizedString("profile_signout_button_accessibility", comment: "Sign out of account"))
                    }
                }
            }
            .padding(.horizontal)
            
            VStack {
                Spacer()
                ZStack(alignment: .topTrailing) {
                    CustomTabBar(currentRoute: .main(.userProfile)) { route in
                        coordinator.push(route)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.background(env))
                    .ignoresSafeArea(edges: .bottom)
                    
                    IconicButton(backgroundColor: Color(hex: "#D0021B")) {
                        navigateToRoute = .main(.eventCreate)
                    }
                    .padding(.trailing, 16)
                    .offset(y: -60)
                    .accessibilityLabel(NSLocalizedString("create_event_button", comment: "Create new event"))
                }
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage.message)
                    .font(.custom("Inter-Regular", size: 16))
                    .foregroundStyle(Color(hex: "#D0021B"))
                    .padding()
                    .background(Color.background_field(env))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .animation(.easeInOut(duration: 0.3), value: errorMessage)
            }
        }
        .task {
            await viewModel.fetchUser(userId: sessionManager.currentUser?.id ?? "")
            notificationsEnabled = viewModel.user?.notificationsEnabled ?? false
        }
        .onChange(of: notificationsEnabled) { _, newValue in
            Task {
                await viewModel.updateNotificationsEnabled(newValue, forUserId: sessionManager.currentUser?.id ?? "")
            }
        }
        .task(id: navigateToRoute) {
            if let route = navigateToRoute {
                if case .auth(.main) = route {
                    coordinator.popToRoot()
                    coordinator.push(.auth(.main))
                } else {
                    coordinator.push(route)
                }
                navigateToRoute = nil
            }
        }
        .alert(NSLocalizedString("profile_signout_alert_title", comment: "Confirm Sign Out"), isPresented: $showSignOutAlert) {
            Button(NSLocalizedString("profile_signout_alert_cancel", comment: "Cancel"), role: .cancel) {}
            Button(NSLocalizedString("profile_signout_alert_confirm", comment: "Sign Out"), role: .destructive) {
                Task {
                    do {
                        try await sessionManager.signOut()
                        navigateToRoute = .auth(.main)
                    } catch {
                        viewModel.errorMessage = IdentifiableError(message: error.localizedDescription)
                    }
                }
            }
        } message: {
            Text(NSLocalizedString("profile_signout_alert_message", comment: "Are you sure you want to sign out?"))
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        UserProfileView()
            .environmentObject(dependencyContainer.sessionManager)
            .environmentObject(dependencyContainer.makeNavigationCoordinator())
    }
}
