//
//  ListRowView.swift
//  Eventorias2
//
//  Created by Alassane Der on 20/07/2025.
//

import SwiftUI

struct ListRowView: View {
    @Environment(\.self) private var env
    @EnvironmentObject private var viewModel: EventListViewModel
    let event: Event
    
    var body: some View {
        HStack {
            /// owner image
            AsyncImage(url: URL(string: viewModel.users[event.ownerId]?.profilePictureUrl ?? "")) { phase in
                switch phase {
                case .empty:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(Color.gray)
                        .accessibilityLabel(NSLocalizedString("loading_owner_image", comment: "Default owner profile picture"))
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .accessibilityLabel(NSLocalizedString("owner_profile_image", comment: "Owner profile picture"))
                case .failure:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(Color.gray)
                        .accessibilityLabel(NSLocalizedString("owner_image_failed", comment: "Failed to load owner profile picture"))
                @unknown default:
                    EmptyView()
                }
            }
            .onAppear {
                print("Owner profile picture URL: \(viewModel.users[event.ownerId]?.profilePictureUrl ?? "No URL")")
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(event.title)
                    .font(.custom("Inter-Medium", size: 18))
                Text("\(event.date, style: .date)")
                    .font(.custom("Inter-Regular", size: 14))
            }
            .padding(.horizontal)
            
            Spacer()
            
            /// event image
            AsyncImage(url: URL(string: event.imageUrl ?? "")) { phase in
                switch phase {
                case .empty:
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 136, height: 80)
                        .foregroundStyle(Color.gray)
                        .accessibilityLabel(NSLocalizedString("loading_event_image", comment: "Default event image"))
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 136, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .accessibilityLabel(NSLocalizedString("event_image", comment: "Event image"))
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 136, height: 80)
                        .foregroundStyle(Color.gray)
                        .accessibilityLabel(NSLocalizedString("event_image_failed", comment: "Failed to load event image"))
                @unknown default:
                    EmptyView()
                }
            }
            .onAppear {
                print("Event image URL: \(String(describing: event.imageUrl))")
            }
        }
        .padding(.vertical, 8)
        .background(Color.background_field(env))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ListRowView(event: Event(id: "mockEventId", title: "Mock Event", description: "Description", address: "adresse", date: Date(), ownerId: "https://via.placeholder.com/40", imageUrl: "https://via.placeholder.com/136x80", location: Event.Location(latitude: 48.8566, longitude: 2.3522)))
            .frame(maxHeight: 80)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
