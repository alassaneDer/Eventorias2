//
//  User.swift
//  Eventorias2
//
//  Created by Alassane Der on 12/07/2025.
//

import FirebaseFirestore
import FirebaseAuth

struct AuthUser: Equatable, Codable, Identifiable {
    @DocumentID var id: String?
    let email: String
    let username: String?
    let profilePictureUrl: String
    let createdAt: Date
    
    init(user: FirebaseAuth.User, username: String? = nil, profilePictureUrl: String = "") {
        self.id = user.uid
        self.email = user.email ?? ""
        self.username = username
        self.profilePictureUrl = profilePictureUrl
        self.createdAt = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "uid"
        case email
        case username
        case profilePictureUrl = "profile_picture_url"
        case createdAt = "created_at"
    }
}
