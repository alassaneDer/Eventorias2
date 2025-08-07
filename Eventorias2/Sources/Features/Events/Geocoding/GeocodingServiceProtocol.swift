//
//  GeocodingServiceProtocol.swift
//  Eventorias2
//
//  Created by Alassane Der on 26/07/2025.
//

import CoreLocation
import Foundation

protocol GeocodingServiceProtocol {
    func geocodeAddress(_ address: String) async throws -> CLLocationCoordinate2D?
}
