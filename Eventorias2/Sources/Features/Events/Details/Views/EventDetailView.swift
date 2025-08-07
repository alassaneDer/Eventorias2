//
//  EventDetailView.swift
//  Eventorias2
//
//  Created by Alassane Der on 20/07/2025.
//
//
//
import SwiftUI
import MapKit

struct EventDetailView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var sessionManager: SessionManager
    @EnvironmentObject private var dependencyContainer: DependencyContainer
    @StateObject var viewModel: EventDetailViewModel
    @Environment(\.self) private var env
    @State private var navigateToRoute: MainRoute?

    var body: some View {
        ZStack(alignment: .top) {
            Color.background(env)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                ScrollView {
                    if let event = viewModel.event {
                        AsyncImage(url: URL(string: event.imageUrl ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 360)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .accessibilityLabel(NSLocalizedString("event_image", comment: "Event image"))
                        } placeholder: {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(maxWidth: 200, maxHeight: 200)
                                .foregroundStyle(Color.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .accessibilityLabel(NSLocalizedString("event_image_default", comment: "Default event image"))
                        }
                        .padding(.bottom)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "calendar")
                                    Text("\(event.date, style: .date)")
                                        .font(.custom("Inter-Regular", size: 14))
                                        .foregroundStyle(Color.gray)
                                }
                                HStack {
                                    Image(systemName: "clock")
                                    Text("\(event.date, style: .time)")
                                        .font(.custom("Inter-Regular", size: 14))
                                        .foregroundStyle(Color.gray)
                                }
                            }
                            
                            Spacer()
                            
                            AsyncImage(url: URL(string: event.imageUrl ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: 60)
                                    .clipShape(Circle())
                                    .accessibilityLabel(NSLocalizedString("event_image", comment: "Event image"))
                            } placeholder: {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(maxWidth: 60)
                                    .clipShape(Circle())
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .accessibilityLabel(NSLocalizedString("event_image_default", comment: "Default event image"))
                            }
                        }
                        
                        Text(event.description ?? "")
                            .font(.custom("Inter-Regular", size: 16))
                            .foregroundStyle(Color.gray)
                        
                        HStack {
                            Text(event.address ?? NSLocalizedString("no_address_provided", comment: "No address provided"))
                                .font(.custom("Inter-Regular", size: 14))
                                .foregroundStyle(Color.gray)
                            
                            Spacer()
                            
                            Map(coordinateRegion: $viewModel.region, interactionModes: .all, annotationItems: [LocationPoint(coordinate: viewModel.region.center)]) { location in
                                MapMarker(coordinate: location.coordinate)
                            }
                            .frame(maxWidth: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .accessibilityLabel(NSLocalizedString("event_location_accessibility", comment: "Event location on map"))
                        }
                        .frame(height: 75)
                        
                        if event.ownerId == sessionManager.currentUser?.id {
                            Button(action: {
                                Task {
                                    await viewModel.deleteEvent()
                                    if viewModel.errorMessage == nil {
                                        navigateToRoute = .eventList
                                    }
                                }
                            }, label: {
                                Text(NSLocalizedString("event_delete_button", comment: "Delete Event"))
                                    .font(.custom("Inter-Regular", size: 16))
                                    .foregroundStyle(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(hex: "#D0021B"))
                                    )
                            })
                            .padding(.top)
                            .accessibilityLabel(NSLocalizedString("event_delete_button_accessibility", comment: "Delete event"))
                        }
                    }
                }
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
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    navigateToRoute = .eventList
                } label: {
                    HStack {
                        Image(systemName: "arrow.backward")
                        if let event = viewModel.event {
                            Text("\(event.title)")
                        }
                    }
                }
                .accessibilityLabel(NSLocalizedString("back_button_accessibility", comment: "Back to event list"))
            }
        }
        .task(id: navigateToRoute) {
            if let route = navigateToRoute {
                if route == .eventList {
                    coordinator.popMain()
                } else {
                    coordinator.push(.main(route))
                }
                navigateToRoute = nil
            }
        }
        .task {
            await viewModel.fetchEvent()
        }
    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        EventDetailView(viewModel: dependencyContainer.makeEventDetailViewModel(eventId: "test"))
            .environmentObject(dependencyContainer.sessionManager)
            .environmentObject(dependencyContainer.makeNavigationCoordinator())
    }
}
