//
//  Routee.swift
//  Eventorias2
//
//  Created by Alassane Der on 15/07/2025.
//
//

import Foundation

enum Route: Hashable {
    case auth(AuthRoute)
    case main(MainRoute)
}

enum AuthRoute: Hashable {
    case main
    case signIn
    case signUp
}

enum MainRoute: Hashable {
    case eventList
    case eventDetail(String)
    case eventCreate
    case userProfile
}
