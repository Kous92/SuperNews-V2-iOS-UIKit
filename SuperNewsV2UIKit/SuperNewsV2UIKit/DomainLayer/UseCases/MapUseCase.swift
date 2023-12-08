//
//  MapUseCase.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 23/05/2023.
//

import Foundation
import CoreLocation

/// This use case loads all countries to the map
final class MapUseCase: MapUseCaseProtocol {
    private let locationRepository: SuperNewsLocationRepository
    private let localFileRepository: SuperNewsLocalFileRepository
    
    init(locationRepository: SuperNewsLocationRepository, localFileRepository: SuperNewsLocalFileRepository) {
        self.locationRepository = locationRepository
        self.localFileRepository = localFileRepository
    }
    
    func fetchUserLocation() async -> Result<CLLocation, SuperNewsGPSError> {
        return await locationRepository.fetchLocation()
    }
    
    func execute() async -> Result<[CountryAnnotationViewModel], SuperNewsLocalFileError> {
        return handleResult(with: await localFileRepository.loadCountries())
    }
    
    func reverseGeocoding(location: CLLocation) async -> Result<String, SuperNewsGPSError> {
        return await locationRepository.reverseGeocoding(location: location)
    }
    
    private func handleResult(with result: Result<[CountryDTO], SuperNewsLocalFileError>) -> Result<[CountryAnnotationViewModel], SuperNewsLocalFileError> {
        switch result {
            case .success(let countries):
                return .success(parseViewModels(with: countries))
            case .failure(let error):
                return .failure(error)
        }
    }
    
    private func parseViewModels(with countries: [CountryDTO]) -> [CountryAnnotationViewModel] {
        var viewModels = [CountryAnnotationViewModel]()
        countries.forEach { viewModels.append(CountryAnnotationViewModel(with: $0)) }
        
        return viewModels
    }
}
