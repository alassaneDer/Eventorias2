//
//  EventDetailView.swift
//  Eventorias2
//
//  Created by Alassane Der on 20/07/2025.
//

import SwiftUI
import MapKit

struct EventDetailView: View {
    @EnvironmentObject private var router: NavigationCoordinator
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var viewModel: EventDetailViewModel
    
    @Environment(\.self) private var env
    
    init(eventId: String) {
        _viewModel = StateObject(wrappedValue: EventDetailViewModel(eventId: eventId))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.background(env)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                Text(NSLocalizedString("event_detail_title", comment: "Event Details"))
                    .font(.custom("Inter-Regular", size: 24))
                    .fontWeight(.bold)
                
                ScrollView {
                    if let event = viewModel.event {
                        AsyncImage(url: URL(string: event.imageUrl ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } placeholder: {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(maxWidth: 200, maxHeight: 200)
                                .foregroundStyle(Color.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(.bottom)
                        
                        Text(event.title)
                            .font(.custom("Inter-Medium", size: 18))
                            .foregroundStyle(Color.primary)
                        
                        Text(event.description)
                            .font(.custom("Inter-Regular", size: 16))
                            .foregroundStyle(Color.gray)
                        
                        Text("\(event.date, style: .date)")
                            .font(.custom("Inter-Regular", size: 14))
                            .foregroundStyle(Color.gray)
                        
                        Text(NSLocalizedString("event_owner", comment: "Owner: \(event.ownerId)"))
                            .font(.custom("Inter-Regular", size: 14))
                            .foregroundStyle(Color.gray)
                        
                        Text(NSLocalizedString("event_location", comment: "Location"))
                            .font(.custom("Inter-Medium", size: 16))
                            .foregroundStyle(Color.primary)
                            .padding(.top)
                        
                        Map(coordinateRegion: .constant(MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude),
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )), interactionModes: [], annotationItems: [LocationPoint(coordinate: CLLocationCoordinate2D(latitude: event.location.latitude, longitude: event.location.longitude))]) { location in
                            MapMarker(coordinate: location.coordinate)
                        }
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        if event.ownerId == sessionManager.currentUser?.id {
                            Button(action: {
                                Task {
                                    await viewModel.deleteEvent()
                                    if viewModel.errorMessage == nil {
                                        router.pop()
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
        .navigationTitle(NSLocalizedString("event_detail_title", comment: "Event Details"))
        .task {
            await viewModel.fetchEvent()
        }
    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        EventDetailView(eventId: "mockEventId")
            .environmentObject(dependencyContainer.sessionManager)
            .environmentObject(dependencyContainer.makeNavigationCoordinator())
    }
}
