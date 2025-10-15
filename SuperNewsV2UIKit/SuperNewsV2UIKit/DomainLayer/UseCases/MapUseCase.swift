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
    private let localFileRepository: SuperNewsLocalFileRepository
    
    nonisolated init(localFileRepository: SuperNewsLocalFileRepository) {
        self.localFileRepository = localFileRepository
    }
    
    @concurrent func execute() async throws -> [CountryAnnotationViewModel] {
        return parseViewModels(with: try await localFileRepository.loadCountries())
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
