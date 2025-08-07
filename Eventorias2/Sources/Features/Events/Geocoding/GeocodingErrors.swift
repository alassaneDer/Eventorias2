//
//  GeocodingErrors.swift
//  Eventorias2
//
//  Created by Alassane Der on 26/07/2025.
//

import Foundation

enum GeocodingErrors: Error, LocalizedError {
    case geocodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .geocodingFailed(let error):
            return NSLocalizedString("geocoding_error_failed", comment: "Failed to geocode address: \(error.localizedDescription)")
        }
    }
}
