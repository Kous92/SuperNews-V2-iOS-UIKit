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
    
    func loadCountries() async throws -> [CountryDTO] {
        guard let countries = try await localFileService?.loadCountries() else {
            throw SuperNewsLocalFileError.localFileError
        }
        
        return countriesToDTO(with: countries)
    }
    
    func loadLanguages() async throws -> [LanguageDTO] {
        guard let languages = try await localFileService?.loadLanguages() else {
            throw SuperNewsLocalFileError.localFileError
        }
        
        return languageToDTO(with: languages)
    }
    
    private func handleCountryResult(with result: Result<[Country], SuperNewsLocalFileError>) -> Result<[CountryDTO], SuperNewsLocalFileError> {
        switch result {
        case .success(let countries):
            return .success(countriesToDTO(with: countries))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func handleLanguageResult(with result: Result<[Language], SuperNewsLocalFileError>) -> Result<[LanguageDTO], SuperNewsLocalFileError> {
        switch result {
        case .success(let languages):
            return .success(languageToDTO(with: languages))
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
    
    /// Converts Language data objects to Language Data Transfer Object for Domain Layer
    private func languageToDTO(with languages: [Language]) -> [LanguageDTO] {
        var dtoList = [LanguageDTO]()
        languages.forEach { dtoList.append(LanguageDTO(with: $0)) }
        
        return dtoList
    }
}
