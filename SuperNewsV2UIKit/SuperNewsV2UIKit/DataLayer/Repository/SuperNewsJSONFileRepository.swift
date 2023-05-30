//
//  SuperNewsJSONFileRepository.swift
//  SuperNewsV2UIKit
//
//  Created by Koussaïla Ben Mamar on 30/05/2023.
//

import Foundation

final class SuperNewsJSONFileRepository: SuperNewsLocalFileRepository {
    private let localFileService: SuperNewsLocalDataFileService?
    
    init(localFileService: SuperNewsLocalDataFileService?) {
        self.localFileService = localFileService
    }
    
    func loadCountries() async -> Result<[CountryDTO], SuperNewsLocalFileError> {
        guard let result = await localFileService?.loadCountries() else {
            return .failure(.localFileError)
        }
        
        return handleCountryResult(with: result)
    }
    
    private func handleCountryResult(with result: Result<[Country], SuperNewsLocalFileError>) -> Result<[CountryDTO], SuperNewsLocalFileError> {
        switch result {
            case .success(let countries):
                return .success(countriesToDTO(with: countries))
            case .failure(let error):
                return .failure(error)
        }
    }
    
    /// Converts Country data objects to Country Data Transfer Object for Domain Layer
    private func countriesToDTO(with countries: [Country]) -> [CountryDTO] {
        var dtoList = [CountryDTO]()
        countries.forEach { dtoList.append(CountryDTO(with: $0)) }
        
        return dtoList
    }
}
