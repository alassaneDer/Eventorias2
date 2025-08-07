//
//  GeocodingService.swift
//  Eventorias2
//
//  Created by Alassane Der on 26/07/2025.
//

import CoreLocation
import Foundation

class GeocodingService: GeocodingServiceProtocol {
    func geocodeAddress(_ address: String) async throws -> CLLocationCoordinate2D? {
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.geocodeAddressString(address)
            if let placemark = placemarks.first, let location = placemark.location {
                print("Geocoded address '\(address)' to coordinates: (\(location.coordinate.latitude), \(location.coordinate.longitude))")
                return location.coordinate
            } else {
                print("No coordinates found for address: \(address)")
                return nil
            }
        } catch {
            print("Geocoding failed for address '\(address)': \(error.localizedDescription)")
            throw GeocodingErrors.geocodingFailed(error)
        }
    }
}
