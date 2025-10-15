//
//  SuperNewsMockLocationService.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 11/07/2023.
//

import Foundation
import CoreLocation

/// Mock location service for unit tests and live preview mode
final class SuperNewsMockLocationService: SuperNewsLocationService {
    
    private let forceFetchFailure: Bool
    
    init(forceFetchFailure: Bool) {
        print("[SuperNewsMockLocationService] Starting")
        self.forceFetchFailure = forceFetchFailure
    }
    
    func fetchLocation() async throws -> CLLocation {
        print("[SuperNewsMockLocationService] Fetching user location")
        
        guard forceFetchFailure == false else {
            throw SuperNewsGPSError.serviceNotAvailable
        }
        
        let mockLocation = CLLocation(latitude: 2.301540063286635, longitude: 48.87255175759405)
        print("[SuperNewsMockLocationService] User location retrieved: \(mockLocation)")
        
        return mockLocation
    }
    
    func reverseGeocoding(location: CLLocation) async throws -> String {
        guard forceFetchFailure == false else {
            throw SuperNewsGPSError.reverseGeocodingFailed
        }
        
        let coordinates = location.coordinate
        
        if coordinates.latitude == 2.301540063286635 && coordinates.longitude == 48.87255175759405 {
            return "France"
        } else {
            throw SuperNewsGPSError.reverseGeocodingFailed
        }
    }
}
