//
//  ListRowView.swift
//  Eventorias2
//
//  Created by Alassane Der on 20/07/2025.
//

import SwiftUI

struct ListRowView: View {
    @Environment(\.self) private var env
    let event: Event
    
    var body: some View {
        HStack {
            // Image du propriétaire (supposée être une image de profil)
            AsyncImage(url: URL(string: event.ownerId)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 40, height: 40)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                case .failure:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(Color.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .onAppear {
                print("Owner image URL: \(event.ownerId)")
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(event.title)
                    .font(.custom("Inter-Medium", size: 18))
                Text("\(event.date, style: .date)")
                    .font(.custom("Inter-Regular", size: 14))
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Image de l'événement
            AsyncImage(url: URL(string: event.imageUrl ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 136, height: 80)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 136, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 136, height: 80)
                        .foregroundStyle(Color.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .onAppear {
                print("Event image URL: \(String(describing: event.imageUrl))")
            }
        }
        .padding(.vertical, 8)
        .background(Color(hex: "1D1B20"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ListRowView(event: Event(id: "mockEventId", title: "Mock Event", description: "Description", date: Date(), ownerId: "https://via.placeholder.com/40", imageUrl: "https://via.placeholder.com/136x80", location: Event.Location(latitude: 48.8566, longitude: 2.3522)))
            .frame(maxHeight: 80)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}


/*
struct ListRowView: View {
    @Environment(\.self) private var env
    var event: Event = Event.sample[0]
    var body: some View {
        
        HStack {
            
            AsyncImagView(imageURL: URL(string: event.ownerId))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 8) {
                Text(event.title)
                    .font(.custom("Inter-Medium", size: 18))
                Text("\(event.date, style: .date)")
                    .font(.custom("Inter-Regular", size: 14))
            }
            .padding(.horizontal)
            
            Spacer()
            
            AsyncImagView(imageURL: URL(string: event.imageUrl ?? ""), imageWidth: 136, imageHeight: 80)

        }
        .padding(.vertical, 8)  /// added
        .backgroundStyle(Color(hex: "1D1B20"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ListRowView(event: Event(id: "mockEventId", title: "Mock Event", description: "Description", date: Date(), ownerId: "mockUserId", imageUrl: "mockEventImageUrl", location: Event.Location(latitude: 48.8566, longitude: 2.3522)))
            .frame(maxHeight: 80)
    }
}
*/
