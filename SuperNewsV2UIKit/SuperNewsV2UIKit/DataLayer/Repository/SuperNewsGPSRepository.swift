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
    
    func fetchLocation() async throws -> CLLocation {
        print("SuperNewsGPSRepository -> Thread \(Thread.currentThread)")
        
        guard let result = try await locationService?.fetchLocation() else {
            throw SuperNewsGPSError.serviceNotAvailable
        }
        
        return result
    }
    
    func reverseGeocoding(location: CLLocation) async throws -> String {
        print("SuperNewsGPSRepository -> Thread \(Thread.currentThread)")
        guard let result = try await locationService?.reverseGeocoding(location: location) else {
            throw SuperNewsGPSError.serviceNotAvailable
        }
        
        return result
    }
}
