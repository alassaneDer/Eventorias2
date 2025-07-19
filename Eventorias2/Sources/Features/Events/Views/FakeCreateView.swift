//
//  FakeCreateView.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//

import SwiftUI
import PhotosUI

struct FakeCreateView: View {
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
                        
                        CreateEventTextField(title: "Description", value: $viewModel.title, placeholder: "event_creation_placeholder_description")
                        
                        
                        EventDateTimePickerView(bindings: EventDateBindings(viewModel: viewModel))
                        
                        CreateEventTextField(title: "Adresse", value: $viewModel.title, placeholder: "event_creation_placeholder_adresse")
                        
                        
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
                                IconicButton(backgroundColor: .primary, iconColor: .black, imageSystemName: "camera")
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
                    }
                }
                .overlay(alignment: .bottom) {
                    Button(action: {
                        ///
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
                }
            }
            .padding(.horizontal)
            
        }
    }
}

struct FakeCreateView_Previews: PreviewProvider {
    static var previews: some View {
        let dependencyContainer = DependencyContainer()
        FakeCreateView()
            .environmentObject(dependencyContainer.sessionManager)
            .environmentObject(dependencyContainer.makeNavigationCoordinator())
    }
}
