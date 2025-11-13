//
//  SuperNewsLocationServiceTestCaller.swift
//  SuperNewsV2UIKitTests
//
//  Created by Koussaïla Ben Mamar on 11/07/2023.
//

import Foundation
import CoreLocation
@testable import SuperNewsV2UIKit

final class SuperNewsLocationServiceTestCaller {
    var invokedFetchLocation = false
    var invokedFetchLocationCount = 0
    var invokedReverseGeocoding = false
    var invokedReverseGeocodingCount = 0
    
    func fetchLocationSuccess() async throws -> CLLocation {
        let locationService = SuperNewsMockLocationService(forceFetchFailure: false)
        invokedFetchLocation = true
        invokedFetchLocationCount += 1
        
        return try await locationService.fetchLocation()
    }
    
    func fetchLocationFailure() async throws -> CLLocation {
        let locationService = SuperNewsMockLocationService(forceFetchFailure: true)
        invokedFetchLocation = true
        invokedFetchLocationCount += 1
        
        return try await locationService.fetchLocation()
    }
    
    func reverseGeocodingSuccess() async throws -> String {
        let locationService = SuperNewsMockLocationService(forceFetchFailure: false)
        invokedReverseGeocoding = true
        invokedReverseGeocodingCount += 1
        
        return try await locationService.reverseGeocoding(location: CLLocation(latitude: 2.301540063286635, longitude: 48.87255175759405))
    }
    
    func reverseGeocodingFailure() async throws -> String {
        let locationService = SuperNewsMockLocationService(forceFetchFailure: true)
        invokedReverseGeocoding = true
        invokedReverseGeocodingCount += 1
        
        return try await locationService.reverseGeocoding(location: CLLocation(latitude: 2.301540063286635, longitude: 48.87255175759405))
    }
}
