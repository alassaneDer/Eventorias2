//
//  EventErrors.swift
//  Eventorias2
//
//  Created by Alassane Der on 18/07/2025.
//

import Foundation

enum EventErrors: Error {
    case eventNotFound
    case unexpectedError(String)
    
    var errorDescription: String {
        switch self {
        case .eventNotFound:
            return NSLocalizedString("event_error_not_found", comment: "Event not found")
        case .unexpectedError(let message):
            return NSLocalizedString("event_error_unexpected", comment: "An unexpected error occurred: \(message)")
        }
    }
}
