//
//  EventListView.swift
//  Eventorias2
//
//  Created by Alassane Der on 15/07/2025.
//
import SwiftUI

struct EventListView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var viewModel = EventListViewModel()
    
    @Environment(\.self) private var env
    
    var body: some View {
        ZStack {
            Color.background(env)
                .ignoresSafeArea(.all)
            
            VStack {
                // Barre de recherche fixe
                SearchBar(text: $viewModel.searchable)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.searchable)
                
                // Scrollable content
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            SortButton {
                                viewModel.toggleSort()
                            }
                            
                            Spacer()
                        }
                        .padding(.top)
                    }
                    
                    // MARK: List event
                    VStack(spacing: 12) {
                        if viewModel.filteredEvents.isEmpty {
                            Text(NSLocalizedString("Empty_list", comment: "List empty"))
                                .font(.custom("Inter-Regular", size: 16))
                                .foregroundStyle(Color.gray)
                        } else {
                            ForEach(viewModel.filteredEvents) { event in
                                Button {
                                    coordinator.push(.eventDetail(event.id ?? ""))
                                } label: {
                                    ListRowView(event: event)
                                        .foregroundStyle(Color.primary)
                                        .padding(.leading)
                                        .background(Color.background_field(env))
                                        .frame(height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .padding(.horizontal)
                                        .scaleEffect(1.0)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: event.id)
                                }
                                .onAppear {
                                    print("Event displayed: \(event.title), imageUrl: \(String(describing: event.imageUrl))")
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                }
                .overlay(alignment: .bottomTrailing) {
                    IconicButton(backgroundColor: Color(hex: "#D0021B")) {
                        coordinator.push(.eventCreate)
                    }
                    .padding(.horizontal)
                }
                
                // Barre fixe en bas
                CustomTabBar(currentRoute: .eventList)
            }
        }
        .task {
            await viewModel.fetchEvents()
            print("Fetched events: \(viewModel.filteredEvents.map { ($0.title, $0.imageUrl ?? "nil") })")
        }
        .onAppear {
            print("EventListView appeared, isAuthenticated: \(sessionManager.isAuthenticated)")
        }
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        EventListView()
            .environmentObject(dependencyContainer.sessionManager)
            .environmentObject(NavigationCoordinator(sessionManager: dependencyContainer.sessionManager))
    }
}
/*
struct EventListView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @StateObject private var viewModel = EventListViewModel()
    
    @Environment(\.self) private var env
    
    var body: some View {
        ZStack {
            Color.background(env)
                .ignoresSafeArea(.all)
            
            VStack {
                // Barre de recherche fixe
                /// SarchBar
                SearchBar(text: $viewModel.searchable)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.searchable)
                
                
                // Scrollable content
                ScrollView {
                    VStack(alignment: .leading,spacing: 12, content: {
                        HStack {
                            SortButton {
                                viewModel.toggleSort()
                            }
                            
                            Spacer()
                        }
                        .padding(.top)
                        
                    })
                    
                    //MARK: List event
                    VStack(spacing: 12) {
                        if viewModel.filteredEvents.isEmpty {
                            Text(NSLocalizedString("Empty_list", comment: "List empty"))
                        } else {
                            ForEach(viewModel.filteredEvents) { event in
                                Button {
                                    coordinator.push(.eventDetail(event.id ?? ""))
                                } label: {
                                    ListRowView(event: event)
                                        .foregroundStyle(Color.primary)
                                        .padding(.leading)
                                        .background(Color.background_field(env))
                                        .frame(height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .padding(.horizontal)
                                        .scaleEffect(1.0)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: event.id)
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                    
                }
                .overlay(alignment: .bottomTrailing) {
                    IconicButton(backgroundColor: Color(hex: "#D0021B")) {
                        coordinator.push(.eventCreate)
                    }
                    .padding(.horizontal)
                }
                
                // Barre fixe en bas
                CustomTabBar(currentRoute: .eventList)
            }
        }
        .task {
            await viewModel.fetchEvents()
        }
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        EventListView()
            .environmentObject(dependencyContainer.sessionManager)
            .environmentObject(dependencyContainer.makeNavigationCoordinator())
    }
}
*/
