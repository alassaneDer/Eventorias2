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
    
    @State private var notificationsEnable = false  /// used for userProfile not here
    
    var body: some View {
        ZStack {
            Color.background(env)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text(NSLocalizedString("event_creation_title", comment: "event creation title"))
                    .font(.custom("Inter-Regular", size: 24))
                    .fontWeight(.bold)
                
                ScrollView {
                    VStack(spacing: 16) {
                        
                        CreateEventTextField(title: "Title", value: $viewModel.title, placeholder: "event_creation_placeholder_title")
                            .padding(.top)
                        
                        CreateEventTextField(title: "Description", value: $viewModel.description, placeholder: "event_creation_placeholder_description")
                        
                        
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
//                            .onTapGesture { coordinate in
//                                viewModel.updateLocation(coordinate: coordinate)
//                            }
                            .padding(.bottom)
                            
                            CreateEventTextField(title: NSLocalizedString("event_creation_latitude_field", comment: "Latitude"), value: $viewModel.latitude, placeholder: "event_creation_placeholder_latitude")
                                .keyboardType(.decimalPad)
                            
                            CreateEventTextField(title: NSLocalizedString("event_creation_longitude_field", comment: "Longitude"), value: $viewModel.longitude, placeholder: "event_creation_placeholder_longitude")
                                .keyboardType(.decimalPad)
                        }
                        
                        CreateEventTextField(title: "Adresse", value: $viewModel.title, placeholder: "event_creation_placeholder_adresse")  /// changer title pour mettre adresse plutard
                        
                        HStack(spacing: 8, content: {
                            Toggle("", isOn: $notificationsEnable)
                                .tint(Color(hex: "#D0021B"))
                                .labelsHidden()
                            
                            Text(NSLocalizedString("user_notification_enable", comment: "toggle button for notifications"))
                            
                            Spacer()
                        })
                        
                        
                        /// Picture
                        HStack {
                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                Image(systemName: "camera")
                                    .foregroundStyle(Color(hex: "#D0021B"))
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(width: 52)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .scaleEffect(1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: UUID())
                                
                            }
                            .onChange(of: selectedPhoto) { newItem, _ in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        viewModel.imageData = data
                                    }
                                }
                            }
                            
                            IconicButton(imageSystemName: "paperclip")
                            /// add action here
                            ///
                        }
                        
                        if let data = viewModel.imageData, let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        }
                        
                        ///
                        Button(action: {
                            Task {
                                await viewModel.createEvent(ownerId: sessionManager.currentUser?.id ?? "")
                                if viewModel.errorMessage == nil {
                                    router.push(.eventList)
                                }
                            }
                        }, label: {
                            Text("validate_event_button_title")
                                .font(.custom("Inter-Regular", size: 20))
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                        .fill(Color(hex: "#D0021B"))
                                )
                        })
                        .disabled(viewModel.isLoading || !viewModel.isFormValid)
                        .overlay {
                            if viewModel.isLoading {
                                ProgressView()
                            }
                        }
                    }
                }
//                .overlay(alignment: .bottom) {
//                    Button(action: {
//                        Task {
//                            await viewModel.createEvent(ownerId: sessionManager.currentUser?.id ?? "")
//                            if viewModel.errorMessage == nil {
//                                router.push(.eventList)
//                            }
//                        }
//                    }, label: {
//                        Text("validate_event_button_title")
//                            .font(.custom("Inter-Regular", size: 20))
//                            .fontWeight(.semibold)
//                            .foregroundStyle(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(
//                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
//                                    .fill(Color(hex: "#D0021B"))
//                            )
//                    })
//                    .disabled(viewModel.isLoading || !viewModel.isFormValid)
//                    .overlay {
//                        if viewModel.isLoading {
//                            ProgressView()
//                        }
//                    }
//                }
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
                //                    .animation(.easeInOut(duration: 0.3), value: errorMessage)
            }
        }
    }
}

struct FakeCreateView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        EventCreateView()
            .environmentObject(dependencyContainer.sessionManager)
            .environmentObject(dependencyContainer.makeNavigationCoordinator())
    }
}
