//
//  FakeCreateView.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//
//
//
import SwiftUI
import PhotosUI
import UIKit

struct EventCreateView: View {
    @Environment(\.self) private var env
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @EnvironmentObject private var dependencyContainer: DependencyContainer
    @StateObject var viewModel: EventCreateViewModel
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showCamera: Bool = false
    @State private var showCameraUnavailableAlert: Bool = false
    @State private var navigateToRoute: MainRoute?
    
    private var isCameraAvailable: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    var body: some View {
        ZStack {
            Color.background(env)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                ScrollView {
                    VStack(spacing: 16) {
                        CreateEventTextField(
                            title: NSLocalizedString("event_creation_title_field", comment: "Title"),
                            value: $viewModel.title,
                            placeholder: "event_creation_placeholder_title"
                        )
                        .padding(.top)
                        
                        CreateEventTextField(
                            title: NSLocalizedString("event_creation_description_field", comment: "Description"),
                            value: $viewModel.description,
                            placeholder: "event_creation_placeholder_description"
                        )
                        
                        EventDateTimePickerView(bindings: EventDateBindings(viewModel: viewModel))
                        
                        CreateEventTextField(
                            title: NSLocalizedString("event_creation_address_field", comment: "Address"),
                            value: $viewModel.address,
                            placeholder: "event_creation_placeholder_address"
                        )
                        
                        HStack(spacing: 16) {
                            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                Image(systemName: "photo")
                                    .foregroundStyle(Color.primary)
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(width: 52)
                                    .background(Color(hex: "#D0021B"))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .scaleEffect(1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: UUID())
                            }
                            .onChange(of: selectedPhoto) { _, newItem in
                                Task {
                                    do {
                                        if let data = try await newItem?.loadTransferable(type: Data.self) {
                                            print("Image selected from library, data size: \(data.count) bytes")
                                            viewModel.imageData = data
                                        } else {
                                            print("No image data loaded from library")
                                            viewModel.errorMessage = IdentifiableError(message: NSLocalizedString("event_image_load_error", comment: "Failed to load image"))
                                        }
                                    } catch {
                                        print("Error loading image from library: \(error.localizedDescription)")
                                        viewModel.errorMessage = IdentifiableError(message: error.localizedDescription)
                                    }
                                }
                            }
                            .accessibilityLabel(NSLocalizedString("event_select_image_accessibility", comment: "Select event image from library"))
                            
                            Button(action: {
                                if isCameraAvailable {
                                    showCamera = true
                                } else {
                                    showCameraUnavailableAlert = true
                                }
                            }) {
                                Image(systemName: "camera")
                                    .foregroundStyle(isCameraAvailable ? Color.primary : Color.gray)
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(width: 52)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(isCameraAvailable ? Color(hex: "#D0021B") : Color.gray.opacity(0.3))
                                    )
                                    .scaleEffect(1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: UUID())
                            }
                            .disabled(!isCameraAvailable)
                            .accessibilityLabel(NSLocalizedString("event_take_photo_accessibility", comment: "Take photo for event"))
                        }
                        
                        if let data = viewModel.imageData, let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.bottom)
                                .accessibilityLabel(NSLocalizedString("event_image_preview_accessibility", comment: "Preview of selected event image"))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            Task {
                                guard let ownerId = sessionManager.currentUser?.id else {
                                    viewModel.errorMessage = IdentifiableError(message: NSLocalizedString("event_error_no_user", comment: "No user logged in"))
                                    return
                                }
                                await viewModel.createEvent(ownerId: ownerId)
                                if viewModel.errorMessage == nil {
                                    navigateToRoute = .eventList
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
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    navigateToRoute = .eventList
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text(NSLocalizedString("event_creation_title", comment: "Create Event"))
                    }
                    .foregroundStyle(.primary)
                }
                .accessibilityLabel(NSLocalizedString("back_button_accessibility", comment: "Back to event list"))
            }
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(imageData: $viewModel.imageData)
        }
        .alert(NSLocalizedString("camera_unavailable_alert_title", comment: "Camera Unavailable"), isPresented: $showCameraUnavailableAlert) {
            Button(NSLocalizedString("ok_button", comment: "OK")) {}
        } message: {
            Text(NSLocalizedString("camera_unavailable_alert_message", comment: "The camera is not available on this device."))
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
    }
}

struct EventCreateView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        EventCreateView(viewModel: dependencyContainer.makeEventCreateViewModel())
            .environmentObject(dependencyContainer.sessionManager)
            .environmentObject(dependencyContainer.makeNavigationCoordinator())
    }
}
