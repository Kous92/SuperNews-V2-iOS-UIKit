//
//  ReverseGeocodingUseCase.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 08/12/2023.
//

import Foundation
import CoreLocation

/// This use case manages the reverse geocoding of a country from user location's coordinates
final class ReverseGeocodingUseCase: ReverseGeocodingUseCaseProtocol {
    private let locationRepository: SuperNewsLocationRepository
    
    init(locationRepository: SuperNewsLocationRepository) {
        self.locationRepository = locationRepository
    }
    
    func execute(location: CLLocation) async -> Result<String, SuperNewsGPSError> {
        return await locationRepository.reverseGeocoding(location: location)
    }
}
