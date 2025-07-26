//
//  EventListView.swift
//  Eventorias2
//
//  Created by Alassane Der on 15/07/2025.
//

import SwiftUI

struct EventListView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var dependencyContainer: DependencyContainer
    @StateObject var viewModel: EventListViewModel
    
    @Environment(\.self) private var env
    
    var body: some View {
        ZStack {
            Color.background(env)
                .ignoresSafeArea(.all)
            
            VStack {
                SearchBar(text: $viewModel.searchable)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.searchable)
                
                ScrollView {
                    HStack {
                        SortButton {
                            viewModel.toggleSort()
                        }
                        Spacer()
                    }
                    
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
                            }
                        }
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                }
            }
            /// CustomTabBar et l'IconicButton
            VStack {
                Spacer()
                ZStack(alignment: .topTrailing) {
                    CustomTabBar(currentRoute: .eventList)
                        .frame(maxWidth: .infinity)
                        .background(Color.background(env))
                        .ignoresSafeArea(edges: .bottom)
                    
                    IconicButton(backgroundColor: Color(hex: "#D0021B")) {
                        coordinator.push(.eventCreate)
                    }
                    .padding(.trailing, 16)
                    .offset(y: -60) // Décalage pour que le bouton flotte au-dessus de la CustomTabBar
                    .accessibilityLabel(NSLocalizedString("create_event_button", comment: "Create new event"))
                }
            }
        }
        .environmentObject(viewModel)
        .task {
            await viewModel.fetchEvents()
        }
    }
}
