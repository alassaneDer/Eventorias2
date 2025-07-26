//
//  FakeCreateView.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//

import SwiftUI
import PhotosUI
import MapKit

struct EventCreateView: View {
    @Environment(\.self) private var env
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var router: NavigationCoordinator
    
    @StateObject private var viewModel = EventCreateViewModel()
    @State private var selectedPhoto: PhotosPickerItem?
    
    var body: some View {
        ZStack {
            Color.background(env)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text(NSLocalizedString("event_creation_title", comment: "Event creation title"))
                    .font(.custom("Inter-Regular", size: 24))
                    .fontWeight(.bold)
                
                ScrollView {
                    VStack(spacing: 16) {
                        CreateEventTextField(title: NSLocalizedString("event_creation_title_field", comment: "Title"), value: $viewModel.title, placeholder: "event_creation_placeholder_title")
                            .padding(.top)
                        
                        CreateEventTextField(title: NSLocalizedString("event_creation_description_field", comment: "Description"), value: $viewModel.description, placeholder: "event_creation_placeholder_description")
                        
                        EventDateTimePickerView(bindings: EventDateBindings(viewModel: viewModel))
                        
                        VStack(alignment: .leading) {
                            Text(NSLocalizedString("event_creation_location_field", comment: "Location"))
                                .font(.custom("Inter-Medium", size: 16))
                                .foregroundStyle(Color.primary)
                            
                            Map(coordinateRegion: $viewModel.mapRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: .none, annotationItems: [viewModel.selectedLocation]) { location in
                                MapMarker(coordinate: location.coordinate)
                            }
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.bottom)
                            .accessibilityLabel(NSLocalizedString("event_location_accessibility", comment: "Event location on map"))
                            
                            CreateEventTextField(title: NSLocalizedString("event_creation_latitude_field", comment: "Latitude"), value: $viewModel.latitude, placeholder: "event_creation_placeholder_latitude")
                                .keyboardType(.decimalPad)
                            
                            CreateEventTextField(title: NSLocalizedString("event_creation_longitude_field", comment: "Longitude"), value: $viewModel.longitude, placeholder:"event_creation_placeholder_longitude")
                                .keyboardType(.decimalPad)
                        }
                        
                        CreateEventTextField(title: NSLocalizedString("event_creation_address_field", comment: "Address"), value: $viewModel.address, placeholder: "event_creation_placeholder_address")
                        
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            Image(systemName: "paperclip")
                                .foregroundStyle(Color.primary)
                                .fontWeight(.bold)
                                .padding()
                                .frame(width: 52)
                                .background(Color(hex: "#D0021B"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .scaleEffect(1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: UUID())
                        }
                        .onChange(of: selectedPhoto) { oldItem, newItem in
                            Task {
                                do {
                                    if let data = try await newItem?.loadTransferable(type: Data.self) {
                                        print("Image selected, data size: \(data.count) bytes")
                                        viewModel.imageData = data
                                    } else {
                                        print("No image data loaded")
                                        viewModel.errorMessage = IdentifiableError(message: NSLocalizedString("event_image_load_error", comment: "Failed to load image"))
                                    }
                                } catch {
                                    print("Error loading image: \(error.localizedDescription)")
                                    viewModel.errorMessage = IdentifiableError(message: error.localizedDescription)
                                }
                            }
                        }
                        .accessibilityLabel(NSLocalizedString("event_select_image_accessibility", comment: "Select event image"))
                        
                        if let data = viewModel.imageData, let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.bottom)
                                .accessibilityLabel(NSLocalizedString("event_image_preview_accessibility", comment: "Preview of selected event image"))
                        }
                        
                        Button(action: {
                            Task {
                                guard let ownerId = sessionManager.currentUser?.id else {
                                    viewModel.errorMessage = IdentifiableError(message: NSLocalizedString("event_error_no_user", comment: "No user logged in"))
                                    return
                                }
                                await viewModel.createEvent(ownerId: ownerId)
                                if viewModel.errorMessage == nil {
                                    router.push(.eventList)
                                }
                            }
                        }, label: {
                            Text(NSLocalizedString("validate_event_button_title", comment: "Validate"))
                                .font(.custom("Inter-Regular", size: 20))
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(hex: "#D0021B"))
                                )
                        })
                        .disabled(viewModel.isLoading || !viewModel.isFormValid)
                        .overlay {
                            if viewModel.isLoading {
                                ProgressView()
                            }
                        }
                        .accessibilityLabel(NSLocalizedString("validate_event_button_accessibility", comment: "Validate and create event"))
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
        .navigationTitle(NSLocalizedString("event_creation_title", comment: "Create Event"))
    }
}

struct EventCreateView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        EventCreateView()
            .environmentObject(dependencyContainer.sessionManager)
            .environmentObject(NavigationCoordinator(sessionManager: dependencyContainer.sessionManager))
    }
}
