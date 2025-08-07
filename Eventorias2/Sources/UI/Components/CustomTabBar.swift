//
//  CustomTabbar.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//
//
import SwiftUI

struct CustomTabBar: View {
    let currentRoute: Route
    let onRouteSelected: (Route) -> Void
    
    @Environment(\.self) private var env
    
    var body: some View {
        HStack {
            Button {
                onRouteSelected(.main(.eventList))
            } label: {
                VStack(spacing: 8) {
                    Image("IconEvent3")
                        .renderingMode(.template)
                        .fontWeight(.bold)
                    Text(NSLocalizedString("tab_event", comment: "Event"))
                        .font(.custom("Inter-Medium", size: 14))
                }
                .foregroundStyle(currentRoute == .main(.eventList) ? Color(hex: "#D0021B") : Color.primary)
                .accessibilityLabel(NSLocalizedString("tab_event_accessibility", comment: "Go to events"))
            }
            .padding(.horizontal)
            .padding(.top, 6)
            .padding(.bottom)
                        
            Button {
                onRouteSelected(.main(.userProfile))
            } label: {
                VStack(spacing: 8) {
                    Image(systemName: "person")
                        .fontWeight(.bold)
                    Text(NSLocalizedString("tab_profile", comment: "Profile"))
                        .font(.custom("Inter-Medium", size: 14))
                }
                .foregroundStyle(currentRoute == .main(.userProfile) ? Color(hex: "#D0021B") : Color.primary)
                .accessibilityLabel(NSLocalizedString("tab_profile_accessibility", comment: "Go to profile"))
            }
            .padding(.horizontal)
            .padding(.top, 6)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity)
        .background(Color.background_field(env))
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(currentRoute: .main(.eventList)) { _ in }
    }
}
