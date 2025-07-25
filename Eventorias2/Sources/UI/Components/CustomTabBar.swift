//
//  CustomTabbar.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//
import SwiftUI

struct CustomTabBar: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var sessionManager: SessionManager
    
    @Environment(\.self) private var env
    
    let currentRoute: Route
    
    var body: some View {
        HStack {
            Button {
                coordinator.push(.eventList)
            } label: {
                VStack(spacing: 8) {
                    Image("IconEvent3")
                        .renderingMode(.template)
                        .fontWeight(.bold)
                    Text(NSLocalizedString("tab_event", comment: "Event"))
                        .font(.custom("Inter-Medium", size: 14))
                }
                .foregroundStyle(currentRoute == .eventList ? Color(hex: "#D0021B") : Color.primary)
                .accessibilityLabel(NSLocalizedString("tab_event_accessibility", comment: "Go to events"))
            }
            .padding()
                        
            Button {
                coordinator.push(.userProfile)
            } label: {
                VStack(spacing: 8) {
                    Image(systemName: "person")
                        .fontWeight(.bold)
                    Text(NSLocalizedString("tab_profile", comment: "Profile"))
                        .font(.custom("Inter-Medium", size: 14))
                }
                .foregroundStyle(currentRoute == .userProfile ? Color(hex: "#D0021B") : Color.primary)
                .accessibilityLabel(NSLocalizedString("tab_profile_accessibility", comment: "Go to profile"))
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.background_field(env))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
//        .padding(.bottom, 8)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        CustomTabBar(currentRoute: .eventList)
            .environmentObject(dependencyContainer.sessionManager)
            .environmentObject(dependencyContainer.makeNavigationCoordinator())
    }
}
