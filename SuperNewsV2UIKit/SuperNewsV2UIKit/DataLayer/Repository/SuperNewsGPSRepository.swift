//
//  SuperNewsGPSRepository.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 23/05/2023.
//

import Foundation
import CoreLocation

final class SuperNewsGPSRepository: SuperNewsLocationRepository {
    private let locationService: SuperNewsLocationService?
    
    init(locationService: SuperNewsLocationService?) {
        self.locationService = locationService
    }
    
    func fetchLocation() async -> Result<CLLocation, SuperNewsGPSError> {
        guard let result = await locationService?.fetchLocation() else {
            return .failure(.serviceNotAvailable)
        }
        
        return result
    }
    
    func reverseGeocoding(location: CLLocation) async -> Result<String, SuperNewsGPSError> {
        guard let result = await locationService?.reverseGeocoding(location: location) else {
            return .failure(.serviceNotAvailable)
        }
        
        return result
    }
}
