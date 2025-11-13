//
//  FetchUserLocationUseCase.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 09/12/2023.
//

import Foundation
import CoreLocation

/// This use case fetches the user GPS location
final class FetchUserLocationUseCase: FetchUserLocationUseCaseProtocol {
    private let locationRepository: SuperNewsLocationRepository
    
    init(locationRepository: SuperNewsLocationRepository) {
        self.locationRepository = locationRepository
    }
    
    func execute() async throws -> CLLocation {
        print("FetchUserLocationUseCase -> Thread \(Thread.currentThread)")
        return try await locationRepository.fetchLocation()
    }
}
