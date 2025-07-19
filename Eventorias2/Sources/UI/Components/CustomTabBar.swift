////
////  CustomTabbar.swift
////  Eventorias2
////
////  Created by Alassane Der on 18/07/2025.
////
//
//import SwiftUI
//
//struct CustomTabBar: View {
//
//    @EnvironmentObject private var coordinator: NavigationCoordinator
//    @EnvironmentObject private var sessionManager: SessionManager
//    
//    @Environment(\.self) private var env
//    
//    var body: some View {
//        HStack {
//            VStack {
//                Button {
//                    /// go to Home
//                    coordinator.push(.main)
//                } label: {
//                    VStack(spacing: 8) {
//                        Image("IconEvent3")
//                            .renderingMode(.template)
//                            .fontWeight(.bold)
//                        Text("Event")
//                    }
//                    .foregroundStyle(router.currentScreen == .home ? Color(hex: "#D0021B") : Color.primary)                        }
//            }
//            .padding()
//            
//            
//            VStack {
//                Button {
//                    /// go to Profile
//                    router.goToProfile()
//                } label: {
//                    VStack(spacing: 8) {
//                        Image(systemName: "person")
//                            .fontWeight(.bold)
//                        Text("Profile")
//                    }
//                    .foregroundStyle(router.currentScreen == .profile ? Color(hex: "#D0021B") : Color.primary)
//                }
//            }
//            .padding()
//        }
//        .frame(maxWidth: .infinity)
//        .background(Color.background(env))
//    }
//}
//
//#Preview {
//    CustomTabBar()
//        .environmentObject(NavigationCoordinator())
//}
