//
//  MapUseCase.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 23/05/2023.
//

import Foundation
import CoreLocation

final class MapUseCase: MapUseCaseProtocol {
    private let locationRepository: SuperNewsLocationRepository
    
    init(locationRepository: SuperNewsLocationRepository) {
        self.locationRepository = locationRepository
    }
    
    func fetchUserLocation() async -> Result<CLLocation, SuperNewsGPSError> {
        return await locationRepository.fetchLocation()
    }
}
