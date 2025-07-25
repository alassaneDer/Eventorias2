//
//  UserProfileView.swift
//  Eventorias2
//
//  Created by Alassane Der on 20/07/2025.
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
    
    @Environment(\.self) private var env
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.background(env)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                Text(NSLocalizedString("profile_title", comment: "User Profile"))
                    .font(.custom("Inter-Regular", size: 24))
                    .fontWeight(.bold)
                
                ScrollView {
                    if let user = viewModel.user {
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            AsyncImage(url: URL(string: user.profilePictureUrl ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundStyle(Color.gray)
                            }
                        }
                        .onChange(of: selectedPhoto) { newItem, _ in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    await viewModel.uploadProfilePicture(data: data, forUserId: sessionManager.currentUser?.id ?? "")
                                }
                            }
                        }
                        .padding(.bottom)
                        .accessibilityLabel(NSLocalizedString("profile_change_photo", comment: "Change profile picture"))
                        
                        Text(user.username ?? NSLocalizedString("profile_anonymous", comment: "Anonymous"))
                            .font(.custom("Inter-Medium", size: 18))
                            .foregroundStyle(Color.primary)
                        
                        Text(user.email)
                            .font(.custom("Inter-Regular", size: 16))
                            .foregroundStyle(Color.gray)
                        
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
                
                CustomTabBar(currentRoute: .userProfile)
            }
            .padding(.horizontal)
            
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
        .navigationTitle(NSLocalizedString("profile_title", comment: "User Profile"))
        .task {
            await viewModel.fetchUser(userId: sessionManager.currentUser?.id ?? "")
            notificationsEnabled = viewModel.user?.notificationsEnabled ?? false
        }
        .onChange(of: notificationsEnabled) { newValue, _ in
            Task {
                await viewModel.updateNotificationsEnabled(newValue, forUserId: sessionManager.currentUser?.id ?? "")
            }
        }
        .alert(NSLocalizedString("profile_signout_alert_title", comment: "Confirm Sign Out"), isPresented: $showSignOutAlert) {
            Button(NSLocalizedString("profile_signout_alert_cancel", comment: "Cancel"), role: .cancel) {}
            Button(NSLocalizedString("profile_signout_alert_confirm", comment: "Sign Out"), role: .destructive) {
                Task {
                    do {
                        try await sessionManager.signOut()
                        coordinator.popToRoot()
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
