//
//  SuperNewsMockLocationService.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 11/07/2023.
//

// n'oublie pas de rajouter un #if DEBUG / #endif sur tes fichiers de Mock afin de ne pas embarquer ce code à la Release
// c'est toujours ça de pris

#if DEBUG
import Foundation
import CoreLocation

/// Mock location service for unit tests and live preview mode
final class SuperNewsMockLocationService: SuperNewsLocationService {
    private let forceFetchFailure: Bool
    
    init(forceFetchFailure: Bool) {
        print("[SuperNewsMockLocationService] Starting")
        self.forceFetchFailure = forceFetchFailure
    }
    
    func fetchLocation() async -> Result<CLLocation, SuperNewsGPSError> {
        print("[SuperNewsMockLocationService] Fetching user location")
        
        guard forceFetchFailure == false else {
            return .failure(.serviceNotAvailable)
        }
        
        let mockLocation = CLLocation(latitude: 2.301540063286635, longitude: 48.87255175759405)
        print("[SuperNewsMockLocationService] User location retrieved: \(mockLocation)")
        
        return .success(mockLocation)
    }
    
    func reverseGeocoding(location: CLLocation) async -> Result<String, SuperNewsGPSError> {
        guard forceFetchFailure == false else {
            return .failure(.reverseGeocodingFailed)
        }
        
        let coordinates = location.coordinate
        if coordinates.latitude == 2.301540063286635 && coordinates.longitude == 48.87255175759405 {
            return .success("France")
        } else {
            return .failure(.reverseGeocodingFailed)
        }
        
    }
}
#endif
